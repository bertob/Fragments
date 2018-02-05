using Transmission;

public class Fragments.TorrentManager{

        private static string CONFIG_DIR = GLib.Path.build_path(GLib.Path.DIR_SEPARATOR_S, Environment.get_user_config_dir(), "fragments");

        public TorrentManager(){
                var settings = Transmission.variant_dict(0);
                Transmission.load_default_settings(ref settings, CONFIG_DIR, "fragments");
                //TODO: Save transmission settings, and restore them

                var session = new Session(CONFIG_DIR, false, settings);
                var constructor = new TorrentConstructor(session);
        }
}
