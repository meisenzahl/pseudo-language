public class PseudoLanguage.Application : GLib.Application {
    private const string VERSION = "0.1";

    private static string directory = "";
    private static bool print_version = false;

    private ApplicationCommandLine application_command_line;

    private const OptionEntry[] OPTIONS = {
        { "version", 'v', 0, OptionArg.NONE, ref print_version,
            "Display version number." },
        { null }
    };

    private Application () {
        Object (
            application_id: "com.github.meisenzahl.pseudo-language",
            flags: ApplicationFlags.HANDLES_COMMAND_LINE
        );
    }

    public override int command_line (ApplicationCommandLine command_line) {
        this.hold ();

        int res = handle_command_line (command_line);

        this.release ();

        return res;
    }

    private string? find_pot_path (string base_path = "po") {
        // Find pot file
        try {
            Dir dir = Dir.open (base_path, 0);
            string? name = null;
            while ((name = dir.read_name ()) != null) {
                if (name.has_suffix (".pot")) {
                    return name;
                }
            }
        } catch (FileError err) {
            stderr.printf (err.message);
        }

        return null;
    }

    private int update_pseudo_language () {
        var po_directory = File.new_for_path (directory);
        if (!po_directory.query_exists ()) {
            application_command_line.print (_("Error: "));
            application_command_line.print (_("Directory \"%s\" doesn't exist. Project is not localized.") + "\n", directory);
            return 1;
        }

        string linguas_path = Path.build_filename (directory, "LINGUAS");
        var linguas_file = File.new_for_path (linguas_path);
        if (!linguas_file.query_exists ()) {
            application_command_line.print (_("Error: "));
            application_command_line.print (_("File \"%s\" doesn't exist. Project is not localized.") + "\n", linguas_path);
            return 1;
        }

        try {
            string linguas_content = "";
            size_t linguas_length;

            FileUtils.get_contents (linguas_path, out linguas_content, out linguas_length);
            if (!("pseudo" in linguas_content.strip ().split ("\n"))) {
                application_command_line.print (_("Updating \"%s\"…") + "\n", linguas_path);

                linguas_content += "pseudo\n";
                FileUtils.set_data (linguas_path, linguas_content.data);
            }
        } catch (Error e) {
            application_command_line.print (_("Error: %s") + "\n", e.message);
            return 1;
        }

        string pseudo_path = Path.build_filename (directory, "pseudo.po");
        var pseudo_file = File.new_for_path (pseudo_path);
        if (!pseudo_file.query_exists ()) {
            var pot_path = find_pot_path ();
            if (pot_path == null) {
                application_command_line.print (_("Error: "));
                application_command_line.print (_("Directory \"%s\" doesn't exist. Project is not localized.") + "\n", directory);
                return 1;
            }

            pot_path = Path.build_filename (directory, pot_path);
            application_command_line.print ("Copying \"%s\" to \"%s\"…" + "\n", pot_path, pseudo_path);
            var pot_file = File.new_for_path (pot_path);

            try {
                pot_file.copy (pseudo_file, FileCopyFlags.NONE);
            } catch (Error e) {
                application_command_line.print (_("Error: %s") + "\n", e.message);
                return 1;
            }
        }

        try {
            application_command_line.print ("Updating \"%s\"…" + "\n", pseudo_path);
            var po = new PortableObject.from_path (pseudo_path);
            po.update ();
        } catch (Error e) {
            critical (e.message);
        }

        return 0;
    }

    private int handle_command_line (ApplicationCommandLine command_line) {
        string[] args = command_line.get_arguments ();

        if (args.length == 1) {
            args = { args[0], "po" };
        }

        unowned string[] tmp = args;

        try {
            var option_context = new OptionContext ("- Pseudo Language");
            option_context.set_help_enabled (true);
            option_context.add_main_entries (OPTIONS, null);

            option_context.parse (ref tmp);
        } catch (OptionError e) {
            command_line.print (_("Error: %s") + "\n", e.message);
            command_line.print (_("Run '%s --help' to see a full list of available options.") + "\n", args[0]);
            return 1;
        }

        directory = tmp[1];

        if (print_version) {
            command_line.print (_("Version: %s") + "\n", VERSION);
            return 0;
        }

        this.application_command_line = command_line;

        return update_pseudo_language ();
    }

    public static int main (string[] args) {
        return new Application ().run (args);
    }
}
