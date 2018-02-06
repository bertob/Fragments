using Gtk;
using GLib;

public class Fragments.App : Gtk.Application {

	private Fragments.Window window;
	private TorrentManager manager;

	public App(){
		application_id = "org.gnome.Fragments";
	}

	protected override void startup () {
		base.startup ();

		setup_actions();

		manager = new TorrentManager();
	}

	protected override void activate (){
		window = new Fragments.Window(this, ref manager);
		this.add_window(window);
		window.present();

		// restore old torrents
		manager.restore_torrents();
	}

	private void setup_actions () {
		var action = new GLib.SimpleAction ("preferences", null);
		action.activate.connect (() => { warning("settings are not working yet"); });
		this.add_action (action);

		action = new GLib.SimpleAction ("about", null);
		action.activate.connect (() => { this.show_about_dialog (); });
		this.add_action (action);

		action = new GLib.SimpleAction ("quit", null);
		action.activate.connect (this.quit);
		this.add_action (action);

		// Setup Appmenu
		var builder = new Gtk.Builder.from_resource ("/org/gnome/Fragments/interface/app-menu.ui");
		var app_menu = builder.get_object ("app-menu") as GLib.MenuModel;
		set_app_menu (app_menu);
	}

        private void show_about_dialog(){
		string[] authors = {
			"Felix Häcker <haecker.felix1207@gmail.com>"
		};

		string[] artists = {
			"Tobias Bernard <tbernard@gnome.org>"
		};

		Gtk.show_about_dialog (window,
			logo_icon_name: "org.gnome.Fragments",
			program_name: "Fragments",
			comments: _("A simple torrent manager"),
			authors: authors,
			artists: artists,
			translator_credits: _("translator-credits"),
			website: "https://github.com/FragmentsApp/Fragments",
			website_label: _("GitHub Homepage"),
			version: Config.VERSION,
			license_type: License.GPL_3_0);
	}

	public static int main (string[] args){
		// Init gtk
		Gtk.init(ref args);

	        var app = new App ();
	        return app.run(args);
        }
}
