using Gtk;
using Transmission;

[GtkTemplate (ui = "/org/gnome/Fragments/ui/torrent-box.ui")]
public class Fragments.TorrentBox : Gtk.ListBoxRow{

        private unowned Torrent torrent;

        [GtkChild] private Label title_label;
        [GtkChild] private Label download_label;
        [GtkChild] private Label upload_label;
        [GtkChild] private ProgressBar progress_bar;
        [GtkChild] private Revealer revealer;

        public signal void timeout_reset();
        private const int search_delay = 1;
        private uint delayed_changed_id;

        public TorrentBox(Torrent torrent){
                this.torrent = torrent;
                reset_timeout();
        }

        private void reset_timeout(){
		timeout_reset();

		if(delayed_changed_id > 0)
			Source.remove(delayed_changed_id);
		delayed_changed_id = Timeout.add(search_delay, update);
        }

        private bool update(){
                title_label.set_text(torrent.name);

                if(torrent.stat_cached != null){
                        progress_bar.set_fraction(torrent.stat_cached.percentDone);
                        //progress_bar.set_text((torrent.stat_cached.percentDone*100).to_string() + " %");

                        download_label.set_text((torrent.stat_cached.pieceDownloadSpeed_KBps/1024).to_string() + " MB/s");
                        upload_label.set_text((torrent.stat_cached.pieceUploadSpeed_KBps/1024).to_string() + " MB/s");
                }

                reset_timeout();
                return false;
        }

        [GtkCallback]
        private bool torrent_box_clicked (){
                revealer.set_reveal_child(!revealer.get_reveal_child());

                return false;
        }

}
