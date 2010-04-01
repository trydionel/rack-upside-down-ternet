require 'rubygems'
require 'nokogiri'

module Rack
  class UpsideDownTernet
    
    def initialize(app, effect = '-flip')
      @app, @effect = app, effect
    end
    
    def call(env)
      @env = env
      @status, @headers, @response = @app.call(env)      
      [@status, @headers, self]
    end
    
    def each(&block)
      @response.each do |content|
        html = content
        
        if @headers['Content-Type'].include? 'text/html'
          document = Nokogiri::HTML(content)
          document.css('img').each do |image|
            image_url = image['src'].gsub(/\?.+/, '')
            if image_url =~ /(gif|jpg|jpeg|png)$/
              filename = image_url.split('/').last
              `curl -so tmp/#{filename} http://#{@env['HTTP_HOST']}/#{image_url}`
              `convert tmp/#{filename} #{@effect} public/images/mod/#{filename}`
              image['src'] = "/images/mod/#{filename}"
            end
          end
          
          html = document.to_html
          @headers['Content-Length'] = html.length
        end
        
        block.call(html)
      end
    end
    
  end
end