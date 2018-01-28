using Gtk;

[GtkTemplate (ui = "/org/gnome/Fragments/ui/window.ui")]
public class Fragments.Window : Gtk.ApplicationWindow {

        private TorrentManager manager;
        [GtkChild] private Gtk.ListBox torrent_listbox;

	public Window (TorrentManager manager) {
	        this.manager = manager;
                this.show_all();

                var provider = new CssProvider ();
                provider.load_from_resource ("/org/gnome/Fragments/interface/adwaita.css");
                StyleContext.add_provider_for_screen (Gdk.Screen.get_default (), provider, Gtk.STYLE_PROVIDER_PRIORITY_USER);
	}

	[GtkCallback]
	private void open_torrent_button_clicked(){
                var filech = new Gtk.FileChooserDialog (_("Open torrent"), this, Gtk.FileChooserAction.OPEN);
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
                        TorrentBox torrent_box = new TorrentBox();
                        //manager.add_torrent_by_path(filech.get_filename(), out torrent_box);
                        torrent_listbox.add(torrent_box);
                }

                filech.close ();
	}
}

