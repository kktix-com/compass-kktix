compass-handlino
================

This extension demostrates how to make your own extension to Compass.app / Fire.app. Please download this extension, unzip and put into `~/.compass/extensions`.

This extension includes 2 project template: "simple" and "project".

"simple" only contains html/css/image files, and there is no `manifest.rb` file. Compass will put them in the right place automatically (it is called "discover").

"project" has lots of files, and use bootstrap-sass in styles.scss. There is some trick in `manifest.rb` to ask Compass not to compile ERB file when creating a new project.

If you want to know more about Compass extension, please check the [official documentation](http://compass-style.org/help/tutorials/extensions/).
