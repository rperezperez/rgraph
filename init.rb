# Include hook code here
require 'rgraph'

ActionController::Base.send :include, Rgraph::Controller
ActionController::Base.send :include, Rgraph
ActiveRecord::Base.send :include, Rgraph::Controller
ActiveRecord::Base.send :include, Rgraph
ActionView::Base.send :include, RgraphHelper

#Copy files in public directories.
['stylesheets', 'javascripts'].each do |asset_type|
  public_dir = File.join(RAILS_ROOT, 'public', asset_type, 'rgraph')
  local_dir = File.join(File.dirname(__FILE__), 'assets', asset_type)
  FileUtils.mkdir public_dir unless File.exists? public_dir
  Dir.entries(local_dir).each do |file|
    next if file =~ /^\./
    FileUtils.cp File.join(local_dir, file), public_dir
  end
end