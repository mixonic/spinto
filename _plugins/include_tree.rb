Jekyll::Post.class_eval do

  def location_on_server
    to_liquid['url']
  end

end

Jekyll::Page.class_eval do

  # It is important that this is the same
  # as the key used on the hash in the watcher.
  def location_on_server
    to_liquid['url']
  end

end

Jekyll::StaticFile.class_eval do

  def location_on_server
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
      if Jekyll::IncludeWatcher.inclusions[file.location_on_server].empty?
        Jekyll::IncludeWatcher.inclusions[file.location_on_server] = []
      end
    end

    # Clean up index.html to be '/'
    Jekyll::IncludeWatcher.inclusions.keys.each do |key|
      matches = key.match(/^(.*\/)index.html$/)
      if matches
        Jekyll::IncludeWatcher.inclusions[matches[1]] = \
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

