Jekyll::Post.class_eval do

  def location_on_server
    to_liquid['url']
  end

  def path_to_source
    "/_posts/#{File.join(@name)}"
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
    # First, render like Jekyll normally does
    render_without_include_tree

    # Set a blank array for files that did not have
    # inclusions fired.
    (pages + posts + static_files).each do |file|
      Jekyll::IncludeWatcher.inclusions[file.location_on_server] ||= {}
      Jekyll::IncludeWatcher.inclusions[file.location_on_server].merge!(source: file.path_to_source)
      if file.respond_to?(:data) && file.data
        data = {}
        ['editable', '_content', 'title', 'description'].each do |key|
          data[key] = file.data[key] if file.data[key]
        end
        Jekyll::IncludeWatcher.inclusions[file.location_on_server].merge!(data)
      end
    end

    # Clean up index.html to be '/'
    Jekyll::IncludeWatcher.inclusions.keys.each do |key|
      matches = key.match(/^(.*\/)index.html$/)
      if matches
        clean_name = if matches[1] == '/'
          matches[1]
        else
          matches[1].gsub(/\/$/, '')
        end
        Jekyll::IncludeWatcher.inclusions[clean_name] = \
          Jekyll::IncludeWatcher.inclusions.delete(key)
      end
    end

    # Write our inclusions to a dot-file
    filename = '.include_tree'
    
    File.open(File.join(source, filename), "w") do |f|
      f.write JSON.dump( Jekyll::IncludeWatcher.inclusions )
    end

    # Ensure Jekyll doesn't clean ths up.
    static_files << Jekyll::StaticFile.new(self, source, "/", filename)
  end

end

