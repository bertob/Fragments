using Gtk;

public enum Fragments.Status{
	DOWNLOADING,
	SEEDING,
	QUEUED,
	STOPPED
}

[GtkTemplate (ui = "/org/gnome/Fragments/ui/torrent.ui")]
public class Fragments.Torrent : Gtk.ListBoxRow{

	private unowned Transmission.Torrent torrent;

	// Torrent name
        [GtkChild] private Label name_label;

	// Status
	public Status status { get; set; }
        [GtkChild] private Label status_label;

	// ETA
        [GtkChild] private Label eta_label;

	// Progress
        [GtkChild] private ProgressBar progress_bar;

	// Seeders
        [GtkChild] private Label seeders_label;

        // Leechers
        [GtkChild] private Label leechers_label;

	// Downloaded bytes
        [GtkChild] private Label downloaded_label;

	// Uploaded bytes
        [GtkChild] private Label uploaded_label;

	// Download speed
        [GtkChild] private Label download_speed_label;

	// Upload speed
        [GtkChild] private Label upload_speed_label;

	// Manual update
	[GtkChild] private Button manual_update_button;

	// Update interval
	private const int search_delay = 1;
        private uint delayed_changed_id;

	// Other
	[GtkChild] private Image mime_type_image;
        [GtkChild] private Image turboboost_image;
        [GtkChild] private Image pause_image;
        [GtkChild] private Image start_image;
        [GtkChild] private Revealer revealer;
        [GtkChild] private Button open_button;

        public Torrent(Transmission.Torrent torrent){
        	this.torrent = torrent;
        	name_label.set_text(torrent.name);

		// set correct mimetype image
        	set_mime_type_image();

		connect_signals();
		reset_timeout();
        }

	private void reset_timeout(){
		if(delayed_changed_id > 0) Source.remove(delayed_changed_id);
		delayed_changed_id = Timeout.add(search_delay, update_information);
        }

	private void connect_signals(){
        	this.notify["status"].connect(() => {
        		if(status == Status.STOPPED){
				start_image.set_visible(true);
				pause_image.set_visible(false);
        		}else{
        			start_image.set_visible(false);
				pause_image.set_visible(true);
        		}
        	});
	}

        public void toggle_revealer (){
                revealer.set_reveal_child(!revealer.get_reveal_child());
        }

        [GtkCallback]
        private void pause_button_clicked(){
		if(status == Status.STOPPED){
			torrent.start();
			start_image.set_visible(false);
			pause_image.set_visible(true);
		}else{
			torrent.stop();
			start_image.set_visible(true);
			pause_image.set_visible(false);
		}
        }

        [GtkCallback]
        private void remove_button_clicked(){
		torrent.remove(false, null);
		torrent = null;
		this.hide();
        }

        [GtkCallback]
        private void manual_update_button_clicked(){
		if(torrent.can_manual_update)
			torrent.manual_update();
		else
			manual_update_button.set_sensitive(false);
        }

        [GtkCallback]
        private void open_button_clicked(){
		//TODO: Implement open button
        }

        [GtkCallback]
        private bool turboboost_switch_state_set(){
                return false;
        }

        public void set_mime_type_image(){
        	// determine mime type
        	string mime_type = "application/x-bittorrent";
		if(torrent.info == null) mime_type = "application/x-bittorrent";
		if (torrent.info.files.length > 1) mime_type = "inode/directory";

		var files = torrent.info.files;
		if (files != null && files.length > 0) {
			bool certain = false;
			mime_type = ContentType.guess (files[0].name, null, out certain);
		}

		// check if icon is available, and set the correct icon
		IconTheme icontheme = new IconTheme();
		if(icontheme.has_icon(ContentType.get_generic_icon_name(mime_type)))
			mime_type_image.set_from_gicon(ContentType.get_symbolic_icon(mime_type), Gtk.IconSize.MENU);
		else
			mime_type_image.set_from_gicon(ContentType.get_symbolic_icon("text-x-generic"), Gtk.IconSize.MENU);

	}

	private bool update_information(){
		if(torrent == null) return false;

		reset_timeout();
		if(torrent.stat_cached == null) return false;

		// Progress
                progress_bar.set_fraction(torrent.stat_cached.percentDone);

                // ETA
                var eta = torrent.stat_cached.eta;
                if(eta != uint.MAX) eta_label.set_text("%s left".printf(Utils.time_to_string(eta)));
		else eta_label.set_text("");

		// Download and Upload Speed
		char[40] buf = new char[40];
		var download_speed = Transmission.String.Units.speed_KBps (buf, torrent.stat_cached.pieceDownloadSpeed_KBps);
		var upload_speed = Transmission.String.Units.speed_KBps (buf, torrent.stat_cached.pieceUploadSpeed_KBps);
		download_speed_label.set_text(download_speed);
		upload_speed_label.set_text(upload_speed);

		// Downloaded and Uploaded Bytes
		downloaded_label.set_text(format_size(torrent.stat_cached.haveValid));
		uploaded_label.set_text(format_size(torrent.stat_cached.uploadedEver));

		// Seeders and Leechers
		leechers_label.set_text(torrent.stat_cached.peersGettingFromUs.to_string());
		seeders_label.set_text(_("%i (%i active)").printf(
			torrent.stat_cached.peersConnected,
			torrent.stat_cached.peersSendingToUs));

		// Set status and generate status text
		string status_text = "";
                switch(torrent.stat_cached.activity){
			case Transmission.Activity.SEED: {
				status_text = _("%s uploaded · %s".printf(
					format_size(torrent.stat_cached.uploadedEver),
					upload_speed));
				status = Status.SEEDING;
				break;}
			case Transmission.Activity.CHECK: {
				status_text = _("Checking files...");
				status = Status.DOWNLOADING;
				break;}
			case Transmission.Activity.STOPPED: {
				status_text = _("Stopped");
				status = Status.STOPPED;
				break;}
			case Transmission.Activity.DOWNLOAD: {
				status_text = _("%s of %s downloaded · %s").printf(
					format_size(torrent.stat_cached.haveValid),
					format_size(torrent.stat_cached.sizeWhenDone),
					download_speed);
				status = Status.DOWNLOADING;
				break;}
			case Transmission.Activity.SEED_WAIT: {
				status_text = _("Queued to seed");
				status = Status.SEEDING;
				break;}
			case Transmission.Activity.CHECK_WAIT: {
				status_text = _("Queued to check files");
				status = Status.DOWNLOADING;
				break;}
			case Transmission.Activity.DOWNLOAD_WAIT: {
				status_text = _("Queued to download");
				status = Status.QUEUED;
				break;}
		}
		status_label.set_text(status_text);

                return false;
        }

}
