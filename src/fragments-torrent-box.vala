using Gtk;

[GtkTemplate (ui = "/org/gnome/Fragments/ui/torrent-box.ui")]
public class Fragments.TorrentBox : Gtk.ListBoxRow{

	private Torrent torrent;

        [GtkChild] private Label title_label;
        [GtkChild] private Label status_label;
        [GtkChild] private Label eta_label;

        [GtkChild] private Label seeders_label;
        [GtkChild] private Label downloaded_label;
        [GtkChild] private Label download_speed_label;
        [GtkChild] private Label leechers_label;
        [GtkChild] private Label uploaded_label;
        [GtkChild] private Label upload_speed_label;

        [GtkChild] private Image turboboost_image;
        [GtkChild] private Image pause_image;
        [GtkChild] private Image start_image;

        [GtkChild] private ProgressBar progress_bar;
        [GtkChild] private Revealer revealer;
        [GtkChild] private EventBox torrent_eventbox;

        public TorrentBox(Torrent torrent){
        	this.torrent = torrent;

        	torrent.notify["name"].connect(() => { title_label.set_text(torrent.name); });
        	torrent.notify["progress"].connect(() => { progress_bar.set_fraction(torrent.progress); });
        	torrent.notify["eta"].connect(() => {
        		if(torrent.eta != uint.MAX)
				eta_label.set_text("%s left".printf(Utils.time_to_string(torrent.eta)));
			else
				eta_label.set_text(" ");
        	});
        	torrent.notify["status"].connect(() => {
        		if(torrent.status == Status.STOPPED){
				start_image.set_visible(true);
				pause_image.set_visible(false);
        		}else{
        			start_image.set_visible(false);
				pause_image.set_visible(true);
        		}
        	});
        	torrent.notify["download-speed"].connect(() => { download_speed_label.set_text(torrent.download_speed); });
        	torrent.notify["upload-speed"].connect(() => { upload_speed_label.set_text(torrent.upload_speed); });
        	torrent.notify["downloaded"].connect(() => { downloaded_label.set_text(format_size(torrent.downloaded)); });
        	torrent.notify["uploaded"].connect(() => { uploaded_label.set_text(format_size(torrent.uploaded)); });
        	torrent.notify["peers-connected"].connect(() => {
        		seeders_label.set_text(_("%i (%i active)").printf(
				torrent.peers_connected,
				torrent.peers_active));
        	});
        	torrent.notify["peers-active"].connect(() => {
			seeders_label.set_text(_("%i (%i active)").printf(
				torrent.peers_connected,
				torrent.peers_active));
        	});
        	torrent.notify["leechers"].connect(() => { leechers_label.set_text(torrent.leechers.to_string()); });
        	torrent.notify["status-text"].connect(() => { status_label.set_text(torrent.status_text); });

                torrent_eventbox.button_press_event.connect(toggle_revealer);

                this.show_all();
        }

        private bool toggle_revealer (){
                revealer.set_reveal_child(!revealer.get_reveal_child());
                return false;
        }

        [GtkCallback]
        private void pause_button_clicked(){
		if(torrent.status == Status.STOPPED)
			torrent.start();
		else
			torrent.stop();
        }

        [GtkCallback]
        private void remove_button_clicked(){
		torrent.remove();
		this.destroy();
        }

        [GtkCallback]
        private void more_peers_button_clicked(){

        }

        [GtkCallback]
        private void open_in_folder_button_clicked(){

        }

        [GtkCallback]
        private bool turboboost_switch_state_set(){
                return false;
        }

}
