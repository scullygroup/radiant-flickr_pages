class FlickrPagesController < ApplicationController
  
  no_login_required
  radiant_layout 'GuestPhotos'
  
  require 'flickr_fu'
  
  before_filter :protect_from_forgery, :except => [:index, :gallery]
  
  def flickr_connect(tag)
    @flickr = Flickr.new('config/flickr.yml')
    config = YAML.load_file("config/flickr.yml")
    @user = config['user']
    
    @photos = @flickr.photos.search(:user_id => "#{@user}", :tags => "#{tag}")
    @results = @photos.paginate(:page => params[:page], :per_page => 1)
  end
  
  def index
    self.flickr_connect("guestbook")

    respond_to do |format|
      format.html
      format.js { render :partial => 'photos' }
    end
  end
  
  def gallery
    params[:tag] = "guestbook" if !params[:tag]
    self.flickr_connect("#{params[:tag]}")
    
    respond_to do |format|
      format.html
      format.js { render :partial => 'photos' }
    end
  end
  
end
