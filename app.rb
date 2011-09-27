require 'sinatra'
require 'feedzirra'

get '/' do
  html = ''

  feed = Feedzirra::Feed.fetch_and_parse("http://techcrunch.com/author/mg-siegler/feed/")
  feed.title
  
  feed.entries.each do |entry|
    html += entry.title
    html += '<br/>'
  end
  
  html
end