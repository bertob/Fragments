public enum Fragments.Status{
	DOWNLOADING,
	SEEDING,
	QUEUED,
	STOPPED
}

public class Fragments.Torrent : Object{

	private unowned Transmission.Torrent torrent;
	public string name { get; set; }

	public double progress { get; set; }
	public int eta { get; set; }
	public Status status { get; set; }

	public string download_speed { get; set; }
	public string upload_speed { get; set; }

	public uint64 downloaded { get; set; }
	public uint64 uploaded { get; set; }

	public int peers_connected { get; set; }
	public int peers_active { get; set; }
	public int leechers { get; set; }

	public string status_text { get; set; }
	public bool can_manual_update { get{return torrent.can_manual_update;} }

	public signal void removed();
	private bool is_removed = false;

        private const int search_delay = 1;
        private uint delayed_changed_id;

	public Torrent (Transmission.Torrent torrent){
		this.torrent = torrent;

		reset_timeout();
	}

	public void stop(){
		torrent.stop();
	}

	public void start(){
		torrent.start();
	}

	public void remove(){
		is_removed = true;
		torrent.remove(false, null);
		removed();
	}

	public void update_torrent(){
		if(can_manual_update) torrent.manual_update();
	}

	private void reset_timeout(){
		if(delayed_changed_id > 0)
			Source.remove(delayed_changed_id);
		delayed_changed_id = Timeout.add(search_delay, update_information);
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

	public bool update_information(){
		if(is_removed) return false;

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
