module Jekyll
  
  class IncludeWatcher < Jekyll::IncludeTag

    @@inclusions = {}
    def self.inclusions; @@inclusions; end

    def render(context)
      Jekyll::IncludeWatcher.inclusions[context.registers[:page]['url']] = \
        (Jekyll::IncludeWatcher.inclusions[context.registers[:page]['url']] || {}).merge(
          @file => true
        )
      super
    end

  end

  module Convertible
  
    # Add any necessary layouts to this convertible document.
    #
    # payload - The site payload Hash.
    # layouts - A Hash of {"name" => "layout"}.
    #
    # Returns nothing.

    # Monkey patched for page passing to tags.
    #
    #  https://github.com/mojombo/jekyll/pull/413
    # 
    def do_layout(payload, layouts)
      info = { :filters => [Jekyll::Filters], :registers => { :site => self.site, :page => payload['page'] } }

      # render and transform content (this becomes the final content of the object)
      payload["pygments_prefix"] = converter.pygments_prefix
      payload["pygments_suffix"] = converter.pygments_suffix

      begin
        self.content = Liquid::Template.parse(self.content).render(payload, info)
      rescue => e
        puts "Liquid Exception: #{e.message} in #{self.name}"
      end

      self.transform

      # output keeps track of what will finally be written
      self.output = self.content

      # recursively render layouts
      layout = layouts[self.data["layout"]]
      used = Set.new([layout])

      while layout
        payload = payload.deep_merge({"content" => self.output, "page" => layout.data})

        begin
          self.output = Liquid::Template.parse(layout.content).render(payload, info)
        rescue => e
          puts "Liquid Exception: #{e.message} in #{self.data["layout"]}"
        end

        if layout = layouts[layout.data["layout"]]
          if used.include?(layout)
            layout = nil # avoid recursive chain
          else
            used << layout
          end
        end
      end
    end

  end

end

Liquid::Template.register_tag('include', Jekyll::IncludeWatcher)
