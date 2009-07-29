desc 'build caches for all.css and all.js (mostly used on server)'
task :build_tag_caches => :environment do
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::AssetTagHelper
  stylesheet_link_tag :all, :cache => true
  javascript_include_tag :all, :cache => true
end