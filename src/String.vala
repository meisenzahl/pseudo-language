public class PseudoLanguage.String : GLib.Object {
    public string s { get; construct; }
    public bool has_plural { get; construct; }

    private static Gee.HashMap<string, string> default_char_map;

    public String (string s, bool has_plural = false) {
        Object (
            s: s,
            has_plural: has_plural
        );
    }

    static construct {
        default_char_map = new Gee.HashMap<string, string> ();
        default_char_map.set ("a", "ààà");
        default_char_map.set ("b", "ƀ");
        default_char_map.set ("c", "ç");
        default_char_map.set ("d", "ð");
        default_char_map.set ("e", "ééé");
        default_char_map.set ("f", "ƒ");
        default_char_map.set ("g", "ĝ");
        default_char_map.set ("h", "ĥ");
        default_char_map.set ("i", "îîî");
        default_char_map.set ("j", "ĵ");
        default_char_map.set ("k", "ķ");
        default_char_map.set ("l", "ļ");
        default_char_map.set ("m", "ɱ");
        default_char_map.set ("n", "ñ");
        default_char_map.set ("o", "ôôô");
        default_char_map.set ("p", "þ");
        default_char_map.set ("q", "ǫ");
        default_char_map.set ("r", "ŕ");
        default_char_map.set ("s", "š");
        default_char_map.set ("t", "ţ");
        default_char_map.set ("u", "ûûû");
        default_char_map.set ("v", "ṽ");
        default_char_map.set ("w", "ŵ");
        default_char_map.set ("x", "ẋ");
        default_char_map.set ("y", "ý");
        default_char_map.set ("z", "ž");
        default_char_map.set ("A", "ÀÀÀ");
        default_char_map.set ("B", "Ɓ");
        default_char_map.set ("C", "Ç");
        default_char_map.set ("D", "Ð");
        default_char_map.set ("E", "ÉÉÉ");
        default_char_map.set ("F", "Ƒ");
        default_char_map.set ("G", "Ĝ");
        default_char_map.set ("H", "Ĥ");
        default_char_map.set ("I", "ÎÎÎ");
        default_char_map.set ("J", "Ĵ");
        default_char_map.set ("K", "Ķ");
        default_char_map.set ("L", "Ļ");
        default_char_map.set ("M", "Ṁ");
        default_char_map.set ("N", "Ñ");
        default_char_map.set ("O", "ÔÔÔ");
        default_char_map.set ("P", "Þ");
        default_char_map.set ("Q", "Ǫ");
        default_char_map.set ("R", "Ŕ");
        default_char_map.set ("S", "Š");
        default_char_map.set ("T", "Ţ");
        default_char_map.set ("U", "ÛÛÛ");
        default_char_map.set ("V", "Ṽ");
        default_char_map.set ("W", "Ŵ");
        default_char_map.set ("X", "Ẋ");
        default_char_map.set ("Y", "Ý");
        default_char_map.set ("Z", "Ž");
    }

    public string localize () {
        string t = "[";

        int i = 0;
        while (i < s.length) {
            var character = s.substring (i, 1);

            if (character == "<") {
                var close_index = s.index_of (">", i);
                if (close_index == -1) {
                    t += character;
                } else {
                    t += s.substring (i, close_index - i);
                    i = close_index;
                }
            } else if (character == "%" && (i + 1 < s.length)) {
                string format = "%";
                int offset = 1;
                while (i + offset < s.length) {
                    var next_character = s.substring (i + offset, 1);
                    if (!(next_character in string.join ("", " ", ",", ":", ";", "?", "!", "[", "/", "-", "(", "<", "{"))) {
                        format += next_character;
                        offset++;
                    } else {
                        break;
                    }
                }

                t += format;
                i += offset - 1;
            } else if (default_char_map.has_key (character)) {
                t += default_char_map.get (character);
            } else {
                t += character;
            }

            i++;
        }

        t += "]";

        return t;
    }
}
