public class Fragments.TorrentManager{

	private Transmission.variant_dict settings;
	private Transmission.Session session;

        private static string CONFIG_DIR = GLib.Path.build_path(GLib.Path.DIR_SEPARATOR_S, Environment.get_user_config_dir(), "fragments");

	private List<Torrent> torrent_list;
	public signal void torrent_added(Torrent torrent);
	public signal void torrent_removed(Torrent torrent);

        public TorrentManager(){
		Transmission.String.Units.mem_init(1024, _("KB"), _("MB"), _("GB"), _("TB"));
		Transmission.String.Units.speed_init(1024, _("KB/s"), _("MB/s"), _("GB/s"), _("TB/s"));

                settings = Transmission.variant_dict(0);
                Transmission.load_default_settings(ref settings, CONFIG_DIR, "fragments");
                session = new Transmission.Session(CONFIG_DIR, false, settings);

		torrent_list = new List<Torrent>();
        }

        public void restore_torrents(){
		var torrent_constructor = new Transmission.TorrentConstructor (session);
		unowned Transmission.Torrent[] transmission_torrents = session.load_torrents (torrent_constructor);
                for (int i = 0; i < transmission_torrents.length; i++) {
                	var torrent = new Torrent(transmission_torrents[i]);
			torrent_list.append(torrent);
			torrent_added(torrent);
		}
        }

	public bool add_torrent_by_path(string path){
		message("Adding torrent by file \"%s\"...", path);

		var torrent_constructor = new Transmission.TorrentConstructor (session);
		torrent_constructor.set_metainfo_from_file (path);
		torrent_constructor.set_download_dir (Transmission.ConstructionMode.FORCE, Environment.get_user_special_dir(GLib.UserDirectory.DOWNLOAD));

		Transmission.ParseResult result;
		int duplicate_id;
		unowned Transmission.Torrent torrent = torrent_constructor.instantiate (out result, out duplicate_id);

		if (result == Transmission.ParseResult.OK) {
			var ftorrent = new Fragments.Torrent(torrent);
			torrent_added(ftorrent);
		}

		return false;
	}

	public bool add_torrent_by_magnet(string magnet){
		message("Adding torrent by magnet link \"%s\"...", magnet);
		warning("not implemented yet");

		return false;
	}
}
