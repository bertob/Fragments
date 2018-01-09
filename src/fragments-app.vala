/* This file is part of Gradio.
 *
 * Gradio is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Gradio is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Gradio.  If not, see <http://www.gnu.org/licenses/>.
 */

using Gtk;
using GLib;
//using Dazzle;

public class Fragments.App : Gtk.Application {

        //private Fragments.Window window;

	public App() {
		Object(application_id: "org.gnome.fragments", flags: ApplicationFlags.FLAGS_NONE);
	}

	protected override void startup () {
                //window = new Fragments.Window();
                //window.show_all();
                //this.add_window(window);
	}

	protected override void activate () {
                //window.present();
                //
                Gtk.ApplicationWindow window = new Gtk.ApplicationWindow (this);
		window.set_default_size (400, 400);
		window.title = "My Gtk.Application";

		Gtk.Label label = new Gtk.Label ("Hello, GTK");
		window.add (label);
		window.show_all ();
	}


        int main (string[] args){
	        var app = new App ();
	        return app.run (args);
        }
}
