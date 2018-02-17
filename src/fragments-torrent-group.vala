using Gtk;

[GtkTemplate (ui = "/org/gnome/Fragments/ui/torrent-group.ui")]
public class Fragments.TorrentGroup : Gtk.Box{

	[GtkChild] private Label title_label;
	private TorrentListBox torrent_listbox;
	private TorrentModel model;

        public TorrentGroup(string title, ref TorrentModel model, bool rearrangeable){
		title_label.set_text(title);
		this.model = model;

		torrent_listbox = new TorrentListBox(rearrangeable);
		torrent_listbox.show_all();
		this.pack_start(torrent_listbox, true, true, 0);

		model.items_changed.connect((pos, removed, added) => {
			if(added == 1) add((int)pos);
			if(removed == 1) remove((int)pos);
			update_visibility();
		});

		torrent_listbox.row_activated.connect((row) => {
			((Torrent)row).toggle_revealer();
		});

		update_visibility();
        }

        private void update_visibility(){
        	if(model.get_n_items() == 0) this.hide();
		else this.show();
        }

        private void add(int pos){
		Torrent torrent = (Torrent)model.get_item(pos);
		torrent_listbox.add_torrent(torrent, pos);
        }

	private void remove(int pos){
		Torrent torrent = (Torrent)torrent_listbox.get_row_at_index(pos);
		torrent_listbox.remove_torrent(torrent);
        }
}
