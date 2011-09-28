require 'sinatra'
require 'feedzirra'
require 'haml'
require File.expand_path('lib/unhyperbole.rb', File.dirname(__FILE__))

get '/' do
  html = ''

  feed = Feedzirra::Feed.fetch_and_parse("http://techcrunch.com/author/mg-siegler/feed/")
  feed.title
  
  feed.entries.each do |entry|
    u = Unhyperbole.new(entry.content)
    html += "<h2><a href=\"#{entry.url}\">#{entry.title}</a></h2>"
    html += '<div>'
    html += u.unhyperbole
    html += "</div>\n"
  end
  
  slogans = [ 'Because sometimes you&#146;ve had enough rhetorical questions.', 'All Siegler. Zero hyperbole.', 'A refreshing blend of great sources and restrained prose.' ]
  slogan = slogans[rand(slogans.size)]
  
  response['Cache-Control'] = 'public, max-age=1000'
  
  haml :index, :locals => { :html => html, :slogan => slogan }
end
