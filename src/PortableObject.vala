public class PseudoLanguage.PortableObject : GLib.Object {
    public string path { get; construct; }
    public string content { get; construct; }

    public PortableObject.from_path (string path) throws GLib.FileError {
        string tmp = "";
        size_t length;

        FileUtils.get_contents (path, out tmp, out length);

        Object (
            path: path,
            content: tmp
        );
    }

    public bool update () {
        string updated_content = "";

        Regex re_msgid, re_key_value;
        try {
            re_msgid = new Regex ("^msgid \"(.+)\"$");
            re_key_value = new Regex ("^\"(.*): (.*)\\\\n\"$");
        } catch (Error e) {
            error (e.message);
        }

        var lines = content.strip ().split ("\n");
        int i = 0;
        while (i < lines.length) {
            var line = lines[i];
            GLib.MatchInfo mi;

            if (re_msgid.match (line, 0, out mi)) {
                string s = mi.fetch (1);

                var next_line = "msgstr \"%s\"".printf (new String (s).localize ());

                updated_content += line + "\n";
                updated_content += next_line + "\n";
                i += 2;
            } else if (re_key_value.match (line, 0, out mi)) {
                string key = mi.fetch (1);
                string value = mi.fetch (2);

                if (key == "Language") {
                    value = "pseudo";
                }
                else if (key == "Content-Type") {
                    value = "text/plain; charset=UTF-8";
                }

                updated_content += "\"%s: %s\\n\"".printf (key, value) + "\n";

                i++;
            } else {
                updated_content += line + "\n";
                i++;
            }
        }

        try {
            FileUtils.set_data (path, updated_content.data);
        } catch (Error e) {
            warning (e.message);
            return false;
        }

        return true;
    }
}
