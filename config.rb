# Timezone to get accurate RSS feed times
Time.zone = "Athens"

# Activate and configure extensions
# https://middlemanapp.com/advanced/configuration/#configuring-extensions

activate :autoprefixer do |prefix|
  prefix.browsers = "last 2 versions"
end

set :build_dir, 'docs'

# Live reloader
activate :livereload

# HAML config
# https://github.com/middleman/middleman/issues/2087#issuecomment-307502952
set :haml, { :format => :html5 }
Haml::TempleEngine.disable_option_validator!

set :css_dir, 'assets/stylesheets'
set :js_dir, 'assets/javascripts'
set :images_dir, 'assets/media/images'
set :url_root, 'http://timen.gr'

# Layouts
# https://middlemanapp.com/basics/layouts/

# Per-page layout changes
page '/*.xml', layout: false
page '/*.json', layout: false
page '/*.txt', layout: false
page '/pages/*', layout: 'page'

# Reload the browser automatically whenever files change
# configure :development do
#   activate :livereload
#   set :markdown, :fenced_code_blocks => true, :smartypants => true, :footnotes => true
#   set :markdown_engine, :redcarpet
#   ignore '*.swp'
# end

# blog platform for guests
activate :blog do |blog|
  blog.name = "shows"
  blog.prefix = "shows"
  blog.layout = "shows"
  blog.summary_separator = /(READMORE)/
  blog.summary_length = 100
  blog.year_link = "{year}.html"
  blog.month_link = "{year}/{month}.html"
  blog.day_link = "{year}/{month}/{day}.html"
  blog.default_extension = ".markdown"
end

# With alternative layout
# page '/path/to/file.html', layout: 'other_layout'

# Proxy pages
# https://middlemanapp.com/advanced/dynamic-pages/

# proxy(
#   '/this-page-has-no-template.html',
#   '/template-file.html',
#   locals: {
#     which_fake_page: 'Rendering a fake page with a local variable'
#   },
# )

# Helpers
# Methods defined in the helpers block are available in templates
# https://middlemanapp.com/basics/helper-methods/

helpers do

  def length(file)
    File.size(file)
  end

  def podcast_logo_uri
    "https://ia601403.us.archive.org/18/items/timis-eneken/timen-logo-web.png"
  end

  def podcast_feed_url
    "https://timis-eneken.github.io/podcast.xml"
  end

  def podcast_summary
    summary ="""
    Η εκπομπή 'Τιμής Ένεκεν' εκθέτει το έργο και το πνεύμα Ελλήνων του 20ου και 21ου αιώνα.
    Παραγωγή, επιμέλεια και παρουσίαση από τον Δαυίβ Ναχμία.
    Ψηφιακό αρχείο διαθέσιμο στην ιστοσελίδα https://timis-eneken.github.io/
    """
    return summary
  end

end

# Build-specific configuration
# https://middlemanapp.com/advanced/configuration/#environment-specific-settings

configure :build do
  activate :minify_css
  activate :minify_javascript
  activate :gzip
  ignore '*.swp'
  set :markdown, :fenced_code_blocks => true, :smartypants => true, :footnotes => true
  set :markdown_engine, :redcarpet
end
