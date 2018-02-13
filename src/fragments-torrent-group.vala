using Gtk;

[GtkTemplate (ui = "/org/gnome/Fragments/ui/torrent-group.ui")]
public class Fragments.TorrentGroup : Gtk.Box{

	[GtkChild] private Label title_label;
	[GtkChild] private ListBox torrent_listbox;
	private TorrentModel model;

        public TorrentGroup(string title, ref TorrentModel model, bool dnd){
		title_label.set_text(title);
		this.model = model;

		model.items_changed.connect((pos, removed, added) => {
			if(added == 1) add((int)pos);
			if(removed == 1) remove((int)pos);
			update_visibility();
		});

		torrent_listbox.row_activated.connect((row) => {
			((Torrent)row).toggle_revealer();
		});
        }

        private void update_visibility(){
        	if(model.get_n_items() == 0) this.hide();
		else this.show();
        }

        private void add(int pos){
		Torrent torrent = (Torrent)model.get_item(pos);
		torrent_listbox.insert(torrent, pos);
        }

	private void remove(int pos){
		Torrent torrent = (Torrent)torrent_listbox.get_row_at_index(pos);
		torrent_listbox.remove(torrent);
        }
}
