Jekyll::Post.class_eval do

  def location_on_server
    to_liquid['url']
  end

  def path_to_source
    "/_posts/#{File.join(@name)}"
  end

end

Jekyll::Layout.class_eval do

  def location_on_server
    nil
  end

  def path_to_source
    "/_layouts/#{File.join(@name)}"
  end

end

Jekyll::Page.class_eval do

  # It is important that this is the same
  # as the key used on the hash in the watcher.
  def location_on_server
    to_liquid['url']
  end

  def path_to_source
    File.join(@dir, @name)
  end

end

Jekyll::StaticFile.class_eval do

  def location_on_server
    File.join(@dir, @name)
  end

  def path_to_source
    File.join(@dir, @name)
  end

end

Jekyll::Site.class_eval do
  require 'json'

  alias :render_without_include_tree :render
  def render
    
    # Clean up this thread.
    #
    Thread.current[:jekyll_inclusions] = {}

    # Render like Jekyll normally does
    #
    render_without_include_tree

    spinto_data = {}

    url_cleaner = lambda {|dirty_url|
      matches = dirty_url.match(/^(.*\/)index.html$/)
      clean_url = dirty_url
      if matches
        clean_url = if matches[1] == '/'
          matches[1]
        else
          matches[1].gsub(/\/$/, '')
        end
      end
      clean_url
    }

    # Add pages to the Spinto data
    #
    spinto_data['pages'] = pages.collect do |page|
      spinto_page_data = {
        'includes'  => (Jekyll::IncludeWatcher.inclusions[page.location_on_server] || []),
        'source_path' => page.path_to_source,
        'url'         => url_cleaner.call( page.location_on_server )
      }
      
      if page.data
        %w{ editable title description }.each do |key|
          spinto_page_data[key] = page.data[key] if page.data[key]
        end
      end

      spinto_page_data
    end.sort {|a,b| a['url'] <=> b['url'] }

    # Add layouts to the Spinto data
    #
    spinto_data['layouts'] = layouts.values.collect do |layout|
      {
        'source_path' => layout.path_to_source
      }
    end.sort {|a,b| a['source_path'] <=> b['source_path'] }

    # Add posts to Spinto data
    #
    %w{ posts unpublished_posts }.each do |post_type|
      spinto_data[post_type] = send(post_type.to_sym).collect do |post|
        spinto_post_data = {
          'source_path' => post.path_to_source,
          'url'         => url_cleaner.call( post.location_on_server ),
          'published'   => post.published
        }
        
        if post.data
          %w{ title description }.each do |key|
            spinto_post_data[key] = post.data[key] if post.data[key]
          end
        end
        spinto_post_data
      end.sort {|a,b| a['url'] <=> b['url'] }
    end

    # Add pages to the Spinto data
    #
    spinto_data['static_files'] = static_files.collect do |file|
      {
        'source_path' => file.path_to_source,
        'url'         => url_cleaner.call( file.location_on_server )
      }
    end.sort {|a,b| a['url'] <=> b['url'] }

    # Write our inclusions to a dot-file
    #
    filename = '.spinto_data'
    
    File.open(File.join(source, filename), "w") do |f|
      f.write JSON.dump( spinto_data )
    end

    # Ensure Jekyll doesn't clean this up.
    #
    static_files << Jekyll::StaticFile.new(self, source, "/", filename)
  end

end
