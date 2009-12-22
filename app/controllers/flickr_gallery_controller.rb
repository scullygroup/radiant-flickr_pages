class FlickrGalleryController < ApplicationController
  
  require 'open-uri'
  require 'nokogiri'
  
  no_login_required
  radiant_layout 'PhotoGallery'

  before_filter :protect_from_forgery, :except => [:index]
  
  def index
    
    config = YAML.load_file("config/flickr.yml")
    @api_key = config['key']
    @user = config['user']
    
    # setid = ""
    
    if !params[:setid]
      sets = Nokogiri::XML(open("http://api.flickr.com/services/rest/?method=flickr.photosets.getList&api_key=#{@api_key}&user_id=#{@user}"))
      first_photoset = sets.xpath("/rsp/photosets/photoset").first
      
      setid = first_photoset['id']
    else
      setid = params[:setid]
    end

    @photoset_photos = Nokogiri::XML(open("http://api.flickr.com/services/rest/?method=flickr.photosets.getPhotos&api_key=#{@api_key}&photoset_id=#{setid}"))
    @photos = []
    
    @photoset_photos.xpath("/rsp/photoset/photo").each do |photo|
      @photos.push(photo)
    end
    
    @results = @photos.paginate(:page => params[:page], :per_page => 1)
    
    respond_to do |format|
      format.html
      format.js { render :partial => 'photos' }
    end
  end
  

end
