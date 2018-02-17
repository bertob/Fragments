using Gtk;

[GtkTemplate (ui = "/org/gnome/Fragments/ui/window.ui")]
public class Fragments.Window : Gtk.ApplicationWindow {

	private TorrentManager manager;
	[GtkChild] private Gtk.Box torrent_group_box;

	public Window (App app, ref TorrentManager manager) {
		GLib.Object(application: app);

		this.manager = manager;
		this.show_all();

		var provider = new CssProvider ();
		provider.load_from_resource ("/org/gnome/Fragments/interface/adwaita.css");
		StyleContext.add_provider_for_screen (Gdk.Screen.get_default (), provider, Gtk.STYLE_PROVIDER_PRIORITY_USER);

		TorrentGroup downloading_group = new TorrentGroup("Downloading", ref manager.downloading_torrents, false);
		TorrentGroup seeding_group = new TorrentGroup("Seeding", ref manager.seeding_torrents, false);
		TorrentGroup queued_group = new TorrentGroup("Queued", ref manager.queued_torrents, true);
		torrent_group_box.add(downloading_group);
		torrent_group_box.add(seeding_group);
		torrent_group_box.add(queued_group);
	}

	[GtkCallback]
	private void open_torrent_button_clicked(){
		var filech = new Gtk.FileChooserDialog (_("Open torrents"), this, Gtk.FileChooserAction.OPEN);
		filech.set_select_multiple (true);
		filech.add_button (_("Cancel"), Gtk.ResponseType.CANCEL);
		filech.add_button (_("Open"), Gtk.ResponseType.ACCEPT);
		filech.set_default_response (Gtk.ResponseType.ACCEPT);
		filech.set_current_folder_uri (GLib.Environment.get_home_dir ());

		var all_files_filter = new Gtk.FileFilter ();
		all_files_filter.set_filter_name (_("All files"));
		all_files_filter.add_pattern ("*");
		var torrent_files_filter = new Gtk.FileFilter ();
		torrent_files_filter.set_filter_name (_("Torrent files"));
		torrent_files_filter.add_mime_type ("application/x-bittorrent");
		filech.add_filter (torrent_files_filter);
		filech.add_filter (all_files_filter);

		if (filech.run () == Gtk.ResponseType.ACCEPT) {
			foreach (string filename in filech.get_filenames()) {
				manager.add_torrent_by_path(filename);
			}
		}

		filech.close ();
	}
}

