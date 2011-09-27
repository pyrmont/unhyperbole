require 'sinatra'
require 'feedzirra'
require File.expand_path('lib/dieperbole.rb', File.dirname(__FILE__))

get '/' do
  html = ''

  feed = Feedzirra::Feed.fetch_and_parse("http://techcrunch.com/author/mg-siegler/feed/")
  feed.title
  
  feed.entries.each do |entry|
    d = Dieperbole.new(entry.content)
    html += entry.title
    html += '<br/>'
    html += d.unhyperbole
  end
  
  html
end
