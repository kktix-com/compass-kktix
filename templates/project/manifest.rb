description 'Handlino Compass Extension'

discover :stylesheets
discover :images
discover :javascripts
discover :fonts
discover :files
discover :directories

html '_layout.html.erb', :erb => false
html '_header.html.erb', :erb => false
html 'index.html.erb', :erb => false
html 'has_sidebar/_layout.html.erb', :erb => false
html 'has_sidebar/_sidebar.html.erb', :erb => false
html 'has_sidebar/index.html.erb', :erb => false
