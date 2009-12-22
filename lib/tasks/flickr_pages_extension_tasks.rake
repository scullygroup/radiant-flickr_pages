namespace :radiant do
  namespace :extensions do
    namespace :flickr_pages do
      
      desc "Runs the migration of the FlickrPages extension"
      task :migrate => :environment do
        require 'radiant/extension_migrator'
        if ENV["VERSION"]
          FlickrPagesExtension.migrator.migrate(ENV["VERSION"].to_i)
        else
          FlickrPagesExtension.migrator.migrate
        end
      end
      
      desc "Copies public assets of the FlickrPages to the instance public/ directory."
      task :update => :environment do
        is_svn_or_dir = proc {|path| path =~ /\.svn/ || File.directory?(path) }
        Dir[FlickrPagesExtension.root + "/public/**/*"].reject(&is_svn_or_dir).each do |file|
          path = file.sub(FlickrPagesExtension.root, '')
          directory = File.dirname(path)
          puts "Copying #{path}..."
          mkdir_p RAILS_ROOT + directory
          cp file, RAILS_ROOT + path
        end
      end  
    end
  end
end
