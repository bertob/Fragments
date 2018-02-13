public class Fragments.TorrentModel : GLib.Object, GLib.ListModel {

	private ListStore items;

	public TorrentModel(){
		items = new ListStore (typeof (Torrent));
		items.items_changed.connect((position, removed, added) => {
			items_changed (position, removed, added);
		});
	}

	public GLib.Object? get_item (uint index) {
		return items.get_item (index);
	}

	public GLib.Type get_item_type () {
		return typeof (Torrent);
	}

	public uint get_n_items () {
		return items.get_n_items();
	}

	public bool contains_torrent(Torrent t){
		for (int i = 0; i < get_n_items(); i ++) {
      			Torrent torrent = (Torrent)get_item (i);
      			if(torrent == t) return true;
		}
		return false;
	}

 	public void add_torrent(Torrent torrent) {
 		items.append(torrent);
 	}

 	public void remove_torrent(Torrent t){
 		for (int i = 0; i < items.get_n_items(); i ++) {
       			Torrent torrent = (Torrent)items.get_item (i);
       			if (torrent == t) {
       				items.remove (i);
       				break;
       			}
		}
 	}

	public Iterator iterator() {
		return new Iterator(this);
	}

	public class Iterator {
		private int index;
		private TorrentModel model;

		public Iterator(TorrentModel model) {
			this.model = model;
		}

		public bool next() {
			if(index < model.get_n_items())
				return true;
			else
				return false;
			}

		public Torrent get() {
			this.index++;
			return (Torrent)this.model.get_item(this.index - 1);
		}
	}
}