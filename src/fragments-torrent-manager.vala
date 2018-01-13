using Transmission;

public class Fragments.TorrentManager{

        private Session session;
        private TorrentConstructor constructor;
        private Transmission.variant_dict settings;

        private List<unowned Transmission.Torrent> torrent_list;
        public signal void new_torrent_box(TorrentBox torrent);

        private static string CONFIG_DIR = GLib.Path.build_path(GLib.Path.DIR_SEPARATOR_S, Environment.get_user_config_dir(), "fragments");

        public TorrentManager(){
                torrent_list = new List<unowned Transmission.Torrent>();

                Transmission.String.Units.mem_init(1024, _("KB"), _("MB"), _("GB"), _("TB"));
                Transmission.String.Units.speed_init(1024, _("KB/s"), _("MB/s"), _("GB/s"), _("TB/s"));

                settings = Transmission.variant_dict(0);
                Transmission.load_default_settings(ref settings, CONFIG_DIR, "fragments");
                //TODO: Save transmission settings, and restore them

                session = new Session(CONFIG_DIR, false, settings);
                constructor = new TorrentConstructor(session);
        }

        ~TorrentManager(){
                session.save_settings(CONFIG_DIR, settings);
        }

        public Transmission.ParseResult add_torrent_by_path(string path){
                constructor = new TorrentConstructor(session);
                constructor.set_metainfo_from_file(path);
                constructor.set_download_dir(ConstructionMode.FORCE, Environment.get_user_special_dir(GLib.UserDirectory.DOWNLOAD));

                ParseResult result;

                int duplicate_id;
                unowned Transmission.Torrent torrent = constructor.instantiate(out result, out duplicate_id);

                if(result == ParseResult.OK){
                        torrent_list.append(torrent);
                        new_torrent_box(new Fragments.TorrentBox(torrent));
                }

                return result;
        }
}
