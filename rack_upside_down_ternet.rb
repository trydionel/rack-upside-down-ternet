require 'rubygems'
require 'nokogiri'

module Rack
  class UpsideDownTernet
    
    def initialize(app, effect)
      @app, @effect = app, effect
    end
    
    def call(env)
      @status, @headers, @response = @app.call(env)
      
      document = Nokogiri::HTML(@response)
      document.css('img').each do |image|
        image_url = image['src']
        if image_url =~ /(.gif|.jpg|.jpeg)/
          filename = image_url.split('/').last
          system "curl -o /tmp/#{filename} #{image_url}"
          system "convert #{@effect} /tmp/#{filename} public/images/flip/#{filename}"
          image['src'] = "/images/flip/#{filename}"
        end
      end
      @response = document.to_html
      
      [@status, @headers, @response]
    end
    
  end
end