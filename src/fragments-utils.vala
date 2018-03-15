public class Fragments.Utils{

        public static string time_to_string (uint total_seconds) {
                uint seconds = (total_seconds % 60);
                uint minutes = (total_seconds % 3600) / 60;
                uint hours = (total_seconds % 86400) / 3600;
                uint days = (total_seconds % (86400 * 30)) / 86400;

                var str_days = ngettext ("%u day", "%u days", days).printf (days);
                var str_hours = ngettext ("%u hour", "%u hours", hours).printf (hours);
                var str_minutes = ngettext ("%u minute", "%u minutes", minutes).printf (minutes);
                var str_seconds = ngettext ("%u second", "%u seconds", seconds).printf (seconds);

                if (days > 0) return "%s, %s".printf (str_days, str_hours);
                if (hours > 0) return "%s, %s".printf (str_hours, str_minutes);
                if (minutes > 0) return "%s".printf (str_minutes);
                if (seconds > 0) return str_seconds;
                return "";
	}

	public static void remove_torrent_from_liststore(ListStore store, Torrent torrent){
		for(int i = 0; i < store.get_n_items(); i++){
			if(store.get_object(i) == torrent) store.remove(i);
		}
	}
}