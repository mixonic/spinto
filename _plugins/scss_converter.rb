# Build .scss files into CSS
#

module Jekyll
  require 'sass'
  class ScssConverter < Converter
    safe true
    priority :normal

    def matches(ext)
      ext =~ /scss/i
    end

    def output_ext(ext)
      ".css"
    end

    def convert(content)
      begin
        Sass::Engine.new(content, :syntax => :scss).render
      rescue StandardError => e
        puts "Scss error:" + e.message
      end
    end
  end
end
