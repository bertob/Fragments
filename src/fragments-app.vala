using Gtk;
using GLib;

public class Fragments.App : Gtk.Application {

        private Fragments.Window window;
        private TorrentManager manager;

	public App() {
	        application_id = "org.gnome.Fragments";

	        manager = new TorrentManager();
	}

	protected override void activate () {
	        window = new Fragments.Window(manager);
		this.add_window(window);
	}

	public static int main (string[] args){
	        var app = new App ();
	        return app.run(args);
        }
}

