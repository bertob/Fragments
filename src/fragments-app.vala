using Gtk;
using GLib;

public class Fragments.App : Gtk.Application {

        private Fragments.Window window;

	public App() {
	        application_id = "org.gnome.Fragments";
	}

	protected override void activate () {
	        window = new Fragments.Window();
	        window.present();
		this.add_window(window);
	}

	public static int main (string[] args){
	        var app = new App ();
	        return app.run(args);
        }
}

