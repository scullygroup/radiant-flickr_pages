module FlickrPagesHelper
  
  require 'open-uri'
  require 'nokogiri'
  
  # Pull all tags for the user
  def get_tags
    config = YAML.load_file("config/flickr.yml")
    @api_key = config['key']
    @user = config['user']

    @doc = Nokogiri::XML(open("http://api.flickr.com/services/rest/?method=flickr.tags.getListUser&api_key=#{@api_key}&user_id=#{@user}"))
    
    flickr_tags =[]
    
    @doc.xpath("/rsp/who/tags/tag").each do |node|
      flickr_tags.push("<li id=\"#{node.text}\"><a href=\"/photogallery?tag=#{node.text}\">#{node.text}</a></li>")
    end
    
    return flickr_tags
  end
  
end
