# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application'

class FlickrPagesExtension < Radiant::Extension
  version "1.0"
  description "A Radiant extension that allows you to add paginated flickr galleries"
  url "http://www.scullytown.com"
  
  define_routes do |map|
    
    #This links to an xml file listing of all the testimonials, defined in the extension tags
    #map.connect 'testimonials', :url => '/testimonials', :controller => "site", :action => "show_page"
    #map.connect '', :controller => "testimonials", :action => "index"
   
    map.with_options(:controller => 'flickr_pages') do |flickr|
      flickr.flickr_page_index '/guestphotos', :action => 'index'
    end
    
    map.with_options(:controller => 'flickr_gallery') do |flickr|
      flickr.flickr_gallery_photos '/navitat-asheville/photo-gallery', :action => 'index'
      flickr.flickr_gallery_photoset '/navitat-asheville/photo-gallery/:setid', :action => 'index'
    end

  end
  
  def activate
    Page.send :include, FlickrPageTags
    NoCachePage
  end
  
  def deactivate
    # admin.tabs.remove "Testimonial"
  end
  
end