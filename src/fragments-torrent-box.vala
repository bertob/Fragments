using Gtk;
using Transmission;

[GtkTemplate (ui = "/org/gnome/Fragments/ui/torrent-box.ui")]
public class Fragments.TorrentBox : Gtk.ListBoxRow{

        private unowned Torrent torrent;

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

        public signal void timeout_reset();
        private const int search_delay = 1;
        private uint delayed_changed_id;

        public TorrentBox(Torrent torrent){
                this.torrent = torrent;

                torrent_eventbox.button_press_event.connect(toggle_revealer);

                this.show_all();
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

                reset_timeout();
                if(torrent.stat_cached == null) return false;

                // Progress
                progress_bar.set_fraction(torrent.stat_cached.percentDone);

                // ETA
                if(torrent.stat_cached.eta != uint.MAX)
                        eta_label.set_text("%s left".printf(Utils.time_to_string(torrent.stat_cached.eta)));
                else
                        eta_label.set_text(" ");

                // Download / Upload Speed
                char[40] buf = new char[40];
                var download_speed = Transmission.String.Units.speed_KBps (buf, torrent.stat_cached.pieceDownloadSpeed_KBps);
                var upload_speed = Transmission.String.Units.speed_KBps (buf, torrent.stat_cached.pieceUploadSpeed_KBps);

                download_speed_label.set_text(download_speed);
                upload_speed_label.set_text(upload_speed);

                // Seeders / Leechers information
                seeders_label.set_text("%i (%i active)".printf(
                        torrent.stat_cached.peersConnected,
                        torrent.stat_cached.peersSendingToUs));

                leechers_label.set_text("%i".printf(
                        torrent.stat_cached.peersGettingFromUs));

                // Downloaded / Uploaded information
                downloaded_label.set_text(format_size(torrent.stat_cached.haveValid));
                uploaded_label.set_text(format_size(torrent.stat_cached.uploadedEver));

                // Status text
                switch(torrent.stat_cached.activity){
                        case Activity.SEED: status_label.set_text("Seeding..."); break;
                        case Activity.CHECK: status_label.set_text("Checking files..."); break;
                        case Activity.STOPPED: status_label.set_text("Torrent is stopped."); break;
                        case Activity.DOWNLOAD: status_label.set_text("Downloading..."); break;
                        case Activity.SEED_WAIT: status_label.set_text("Queued to seed."); break;
                        case Activity.CHECK_WAIT: status_label.set_text("Queued to check files."); break;
                        case Activity.DOWNLOAD_WAIT: status_label.set_text("Queued to download."); break;
                }

                return false;
        }

        private bool toggle_revealer (){
                revealer.set_reveal_child(!revealer.get_reveal_child());
                return false;
        }

        [GtkCallback]
        private void pause_button_clicked(){

        }


        [GtkCallback]
        private void remove_button_clicked(){

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
