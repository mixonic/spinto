# Build .sass files into CSS
#

module Jekyll
  require 'sass'
  require 'compass'
  class SassConverter < Converter
    safe true
    priority :normal

    def matches(ext)
      ext =~ /sass/i
    end

    def output_ext(ext)
      ".css"
    end

    def convert(content)
      begin
        Sass::Engine.new(content, :syntax => :sass).render
      rescue StandardError => e
        puts "Sass error:" + e.message
      end
    end
  end
end
