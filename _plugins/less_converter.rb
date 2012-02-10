# Build .less files into CSS
#

module Jekyll
  require 'less'
  class LessConverter < Converter
    safe true
    priority :normal

    def matches(ext)
      ext =~ /less/i
    end

    def output_ext(ext)
      ".css"
    end

    def convert(content)
      begin
        Less::Engine.new(content).to_css
      rescue StandardError => e
        puts "Less error:" + e.message
      end
    end
  end
end
