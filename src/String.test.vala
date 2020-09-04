namespace PseudoLanguage {
    void assert_string (string s1, string s2) {
        if (s1 != s2) {
            print ("%s != %s\n", s1, s2);
        }

        assert (s1 == s2);
    }

    void main (string[] args) {
        Test.init (ref args);

        Test.add_func ("/String/hello-world", () => {
            assert_string (new String ("Hello, world!").localize (), "[Ĥéééļļôôô, ŵôôôŕļð!]");
        });

        Test.add_func ("/String/sprintf", () => {
            assert_string (new String ("Single string %s place-holder.").localize (), "[Šîîîñĝļééé šţŕîîîñĝ %s þļàààçééé-ĥôôôļðéééŕ.]");
            assert_string (new String ("Two %s string %s place-holders.").localize (), "[Ţŵôôô %s šţŕîîîñĝ %s þļàààçééé-ĥôôôļðéééŕš.]");
            assert_string (new String ("This ends with a string place-holder %s").localize (), "[Ţĥîîîš éééñðš ŵîîîţĥ ààà šţŕîîîñĝ þļàààçééé-ĥôôôļðéééŕ %s]");
            assert_string (new String ("This ends with two string place-holders %s%s").localize (), "[Ţĥîîîš éééñðš ŵîîîţĥ ţŵôôô šţŕîîîñĝ þļàààçééé-ĥôôôļðéééŕš %s%s]");
            assert_string (new String ("Positional string %1$s place-holder.").localize (), "[Þôôôšîîîţîîîôôôñàààļ šţŕîîîñĝ %1$s þļàààçééé-ĥôôôļðéééŕ.]");
            assert_string (new String ("Two positional %2$s string %1$s place-holders.").localize (), "[Ţŵôôô þôôôšîîîţîîîôôôñàààļ %2$s šţŕîîîñĝ %1$s þļàààçééé-ĥôôôļðéééŕš.]");
            assert_string (new String ("Float %.2f place-holder.").localize (), "[Ƒļôôôàààţ %.2f þļàààçééé-ĥôôôļðéééŕ.]");
        });

        Test.run ();
    }
}
