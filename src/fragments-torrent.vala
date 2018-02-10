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
	public string name { get; set; }
        [GtkChild] private Label name_label;

	// Status
	public Status status { get; set; }
	public string status_text { get; set; }
        [GtkChild] private Label status_label;

	// ETA
        public int eta { get; set; }
        [GtkChild] private Label eta_label;

	// Progress
	public double progress { get; set; }
        [GtkChild] private ProgressBar progress_bar;

	// Seeders
	public int peers_connected { get; set; }
	public int peers_active { get; set; }
        [GtkChild] private Label seeders_label;

        // Leechers
        public int leechers { get; set; }
        [GtkChild] private Label leechers_label;

	// Downloaded bytes
        public uint64 downloaded { get; set; }
        [GtkChild] private Label downloaded_label;

	// Uploaded bytes
        public uint64 uploaded { get; set; }
        [GtkChild] private Label uploaded_label;

	// Download speed
	public string download_speed { get; set; }
        [GtkChild] private Label download_speed_label;

	// Upload speed
	public string upload_speed { get; set; }
        [GtkChild] private Label upload_speed_label;

	// Manual update
	public bool can_manual_update { get{return torrent.can_manual_update;} }
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
		connect_signals();
		reset_timeout();

		// Set mimetype icon
		IconTheme icontheme = new IconTheme();
		if(icontheme.has_icon(ContentType.get_generic_icon_name(get_mime_type())))
			mime_type_image.set_from_gicon(ContentType.get_symbolic_icon(get_mime_type()), Gtk.IconSize.MENU);
		else
			mime_type_image.set_from_gicon(ContentType.get_symbolic_icon("text-x-generic"), Gtk.IconSize.MENU);

                revealer.set_reveal_child(false);
        }

	private void connect_signals(){
        	this.notify["name"].connect(() => { name_label.set_text(name); });
        	this.notify["progress"].connect(() => { progress_bar.set_fraction(progress); });
        	this.notify["eta"].connect(() => {
        		if(eta != uint.MAX)
				eta_label.set_text("%s left".printf(Utils.time_to_string(eta)));
			else
				eta_label.set_text(" ");
        	});
        	this.notify["status"].connect(() => {
        		if(status == Status.STOPPED){
				start_image.set_visible(true);
				pause_image.set_visible(false);
        		}else{
        			start_image.set_visible(false);
				pause_image.set_visible(true);
        		}
        	});
        	this.notify["download-speed"].connect(() => { download_speed_label.set_text(download_speed); });
        	this.notify["upload-speed"].connect(() => { upload_speed_label.set_text(upload_speed); });
        	this.notify["downloaded"].connect(() => { downloaded_label.set_text(format_size(downloaded)); });
        	this.notify["uploaded"].connect(() => { uploaded_label.set_text(format_size(uploaded)); });
        	this.notify["peers-connected"].connect(() => {
        		seeders_label.set_text(_("%i (%i active)").printf(
				peers_connected,
				peers_active));
        	});
        	this.notify["peers-active"].connect(() => {
			seeders_label.set_text(_("%i (%i active)").printf(
				peers_connected,
				peers_active));
        	});
        	this.notify["leechers"].connect(() => { leechers_label.set_text(leechers.to_string()); });
        	this.notify["status-text"].connect(() => { status_label.set_text(status_text); });

                this.notify.connect(() => {toggle_revealer(); });
	}

	private void reset_timeout(){
		if(delayed_changed_id > 0)
			Source.remove(delayed_changed_id);
		delayed_changed_id = Timeout.add(search_delay, update_information);
        }

        private bool toggle_revealer (){
                revealer.set_reveal_child(!revealer.get_reveal_child());
                return false;
        }

        [GtkCallback]
        private void pause_button_clicked(){
		if(status == Status.STOPPED)
			torrent.start();
		else
			torrent.stop();
		update_information();
        }

        [GtkCallback]
        private void remove_button_clicked(){
		torrent.remove(false, null);
		torrent = null;
		this.hide();
        }

        [GtkCallback]
        private void manual_update_button_clicked(){
		if(can_manual_update)
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

        public string get_mime_type(){
		if(torrent.info == null) return "application/x-bittorrent";
		if (torrent.info.files.length > 1) return "inode/directory";

		var files = torrent.info.files;
		if (files != null && files.length > 0) {
			bool certain = false;
			return ContentType.guess (files[0].name, null, out certain);
		}

		return "application/x-bittorrent";
	}

	private bool update_information(){
		if(torrent == null) return false;

		reset_timeout();
                name = torrent.name;

                if(torrent.stat_cached == null) return false;

                progress = torrent.stat_cached.percentDone;
		eta = torrent.stat_cached.eta;

		char[40] buf = new char[40];
		download_speed = Transmission.String.Units.speed_KBps (buf, torrent.stat_cached.pieceDownloadSpeed_KBps);
                upload_speed = Transmission.String.Units.speed_KBps (buf, torrent.stat_cached.pieceUploadSpeed_KBps);

                downloaded = torrent.stat_cached.haveValid;
                uploaded = torrent.stat_cached.uploadedEver;

                peers_connected = torrent.stat_cached.peersConnected;
                peers_active = torrent.stat_cached.peersSendingToUs;
		leechers = torrent.stat_cached.peersGettingFromUs;

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

                return false;
        }

}
