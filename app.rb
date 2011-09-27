require 'sinatra'
require 'feedzirra'
require 'haml'
require File.expand_path('lib/dieperbole.rb', File.dirname(__FILE__))

get '/' do
  html = ''

  feed = Feedzirra::Feed.fetch_and_parse("http://techcrunch.com/author/mg-siegler/feed/")
  feed.title
  
  feed.entries.each do |entry|
    d = Dieperbole.new(entry.content)
    html += "<a href=\"#{entry.url}\">#{entry.title}</a>"
    html += "<br/>\n"
    html += '<div style="border: 1px solid #888; padding: 10px;">'
    html += d.unhyperbole
    html += "</div>\n"
  end
  
  html
end
