using Gtk;

[GtkTemplate (ui = "/org/gnome/Fragments/ui/torrent-group.ui")]
public class Fragments.TorrentGroup : Gtk.Box{

	[GtkChild] private Label title_label;
	[GtkChild] private ListBox torrent_listbox;

	private List<Torrent> torrent_list;

        public TorrentGroup(string title, bool dnd){
		title_label.set_text(title);

		torrent_list = new List<Torrent>();
        }

        public void add_torrent(Torrent torrent){
		torrent_list.insert(torrent, 0);
		torrent_listbox.add(torrent);
        }
}
