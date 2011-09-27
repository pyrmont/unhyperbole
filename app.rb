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
    html += "<h2><a href=\"#{entry.url}\">#{entry.title}</a></h2>"
    html += '<div>'
    html += d.unhyperbole
    html += "</div>\n"
  end
  
  haml :index, :locals => { :html => html } 
end
