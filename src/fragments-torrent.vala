public class Fragments.Torrent {
	private unowned Transmission.Torrent torrent;

	public string name {
		get {
			return torrent.name;
		}
	}

	public float progress {
		get {
			if (torrent.stat_cached != null) {
				return torrent.stat_cached.percentComplete;
			} else {
				return 0.0f;
			}
		}
	}

	public int seconds_remaining {
		get {
			if (torrent.stat_cached != null) {
				return torrent.stat_cached.eta;
			} else {
				return -1;
			}
		}
	}

	public uint64 bytes_downloaded {
		get {
			if (torrent.stat_cached != null) {
				return torrent.stat_cached.haveValid;
			} else {
				return 0;
			}
		}
	}

	public uint64 bytes_uploaded {
		get {
			if (torrent.stat_cached != null) {
				return torrent.stat_cached.uploadedEver;
			} else {
				return 0;
			}
		}
	}

	public uint64 bytes_total {
		get {
			if (torrent.stat_cached != null) {
				return torrent.stat_cached.sizeWhenDone;
			} else {
				return 0;
			}
		}
	}

	public int connected_peers {
		get {
			if (torrent.stat_cached != null) {
				return torrent.stat_cached.peersConnected;
			} else {
				return 0;
			}
		}
	}

	public int total_peers {
		get {
			int total = 0;
			if (torrent.stat_cached != null) {
				for (int i = 0; i < torrent.stat_cached.peersFrom.length; i++) {
					total += torrent.stat_cached.peersFrom[i];
				}
			}
			return total;
		}
	}

	public bool paused {
		get {
			if (torrent.stat != null) {
				return torrent.stat.activity == Transmission.Activity.STOPPED;
			} else {
				return false;
			}
		}
	}

	public bool downloading {
		get {
			if (torrent.stat_cached != null) {
				return torrent.stat_cached.activity == Transmission.Activity.DOWNLOAD;
			} else {
				return false;
			}
		}
	}

	public bool seeding {
		get {
			if (torrent.stat_cached != null) {
				return torrent.stat_cached.activity == Transmission.Activity.SEED;
			} else {
				return false;
			}
		}
	}

	public bool waiting {
		get {
			if (torrent.stat_cached != null) {
				return torrent.stat_cached.activity == Transmission.Activity.DOWNLOAD_WAIT ||
					   torrent.stat_cached.activity == Transmission.Activity.SEED_WAIT;
			} else {
				return false;
			}
		}
	}

	public bool has_metadata {
		get {
			if (torrent.stat_cached != null) {
				return torrent.stat_cached.metadataPercentComplete == 1.0f;
			} else {
				return false;
			}
		}
	}

	public int file_count {
		get {
			if (torrent.info != null) {
				return torrent.info.files.length;
			} else {
				return -1;
			}
		}
	}

	public Transmission.File[]? files {
		get {
			if (torrent.info != null) {
				return torrent.info.files;
			} else {
				return null;
			}
		}
	}

	public float download_speed {
		get {
			if (torrent.stat_cached != null) {
				return torrent.stat_cached.pieceDownloadSpeed_KBps;
			} else {
				return 0.0f;
			}
		}
	}

	public float upload_speed {
		get {
			if (torrent.stat_cached != null) {
				return torrent.stat_cached.pieceUploadSpeed_KBps;
			} else {
				return 0.0f;
			}
		}
	}

	public time_t date_added {
		get {
			if (torrent.stat_cached != null) {
				return torrent.stat_cached.addedDate;
			} else {
				return time_t ();
			}
		}
	}

	public string download_directory {
		get {
			return torrent.current_dir;
		}
	}

	public int id {
		get {
			return torrent.id;
		}
	}

	public void pause () {
		torrent.stop ();
	}

	public void unpause () {
		torrent.start ();
	}

	public void remove () {
		torrent.remove (false, null);
	}

	public Torrent (Transmission.Torrent torrent) {
		this.torrent = torrent;
	}
}
