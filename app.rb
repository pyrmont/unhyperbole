require 'sinatra'
require 'feedzirra'

get '/' do
  feed = Feedzirra::Feed.fetch_and_parse("http://techcrunch.com/author/mg-siegler/feed/")
  feed.title
end