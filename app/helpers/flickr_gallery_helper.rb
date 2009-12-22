module FlickrGalleryHelper
  
  require 'open-uri'
  require 'nokogiri'
  
  # Pull all photosets for the user
  def get_photosets
    config = YAML.load_file("config/flickr.yml")
    @api_key = config['key']
    @user = config['user']

    @doc = Nokogiri::XML(open("http://api.flickr.com/services/rest/?method=flickr.photosets.getList&api_key=#{@api_key}&user_id=#{@user}"))
    
    first = true
    flickr_photosets = []
    
    @doc.xpath("/rsp/photosets/photoset").each do |node|
      title = node.children
      
      # get the first photo in the set for the primary photo
      @photoset_photos = Nokogiri::XML(open("http://api.flickr.com/services/rest/?method=flickr.photosets.getPhotos&api_key=#{@api_key}&photoset_id=#{node['id']}&per_page=1"))
      first_photo = @photoset_photos.xpath("/rsp/photoset/photo").first
      
      # now take that id and find me the actual photo
      @set_photo = Nokogiri::XML(open("http://api.flickr.com/services/rest/?method=flickr.photos.getSizes&api_key=#{@api_key}&photo_id=#{first_photo['id']}"))
      
      set_photo = ""
      
      @set_photo.xpath("/rsp/sizes/size").each do |size|
        if size['label'] == "Square"
          set_photo = size['source']
        end
      end
      
      a_class = ""
      
      if !params[:setid] && first
        a_class = "current"
      elsif params[:setid] == node['id']
        a_class = "current"
      end
      
      flickr_photosets.push("<a class=\"#{a_class}\" href=\"/photogallery/#{node['id']}\"><img src=\"#{set_photo}\" /><span>#{title.text}</span></a>")
      
      # its not the first run through
      first = false
    end
    
    return flickr_photosets
  end

  def get_photo(photo_id, photo_size)
    config = YAML.load_file("config/flickr.yml")
    api_key = config['key']
    
    photoset_photo = Nokogiri::XML(open("http://api.flickr.com/services/rest/?method=flickr.photos.getSizes&api_key=#{api_key}&photo_id=#{photo_id}"))

    set_photo = ""
    
    photoset_photo.xpath("/rsp/sizes/size").each do |size|
      if size['label'] == photo_size
        set_photo = size['source']
      end
    end
    
    return set_photo
    
  end
  
  def get_setname
    config = YAML.load_file("config/flickr.yml")
    api_key = config['key']
    user = config['user']
    
    if !params[:setid]
      sets = Nokogiri::XML(open("http://api.flickr.com/services/rest/?method=flickr.photosets.getList&api_key=#{api_key}&user_id=#{user}"))
      first_photoset = sets.xpath("/rsp/photosets/photoset").first
      
      setid = first_photoset['id']
    else
      setid = params[:setid]
    end
    
    setinfo = Nokogiri::XML(open("http://api.flickr.com/services/rest/?method=flickr.photosets.getInfo&api_key=#{api_key}&photoset_id=#{setid}"))
    set_title = setinfo.xpath("/rsp/photoset/title").first
    
    return set_title.text
  end
  

end
