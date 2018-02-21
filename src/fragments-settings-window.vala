using Gtk;

[GtkTemplate (ui = "/org/gnome/Fragments/ui/settings-window.ui")]
public class Fragments.SettingsWindow : Gtk.Window {

	[GtkChild] private Switch dark_theme_switch;
	[GtkChild] private SpinButton max_downloads_spinbutton;
	[GtkChild] private FileChooserButton download_folder_button;

	public SettingsWindow () {
		this.show_all();

		dark_theme_switch.active = App.settings.enable_dark_theme;
		max_downloads_spinbutton.value = App.settings.max_downloads;
		download_folder_button.set_current_folder(App.settings.download_folder);

		connect_signals();
	}

	private void connect_signals(){
		dark_theme_switch.state_set.connect(() => {
			App.settings.enable_dark_theme = dark_theme_switch.active;
			return false;
		});

		max_downloads_spinbutton.value_changed.connect(() => {
			App.settings.max_downloads = (int)max_downloads_spinbutton.value;
		});
	}
}

