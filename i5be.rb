['rubygems','sinatra','dm-core','dm-aggregates','dm-timestamps'].each {|f| require f}
set :run => false, :reload => true
DataMapper.setup(:default, YAML::load(File.open('database.yml'))[Sinatra::Application.environment])
class Url
  CHARS= "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789" unless defined?(CHARS)
  include DataMapper::Resource
  property :id,         Serial
  property :target,     String, :format => :url,    :length => 0..255, :index => true
  property :short,      String, :nullable => false, :length => 0..255, :unique_index => true, :default => ""
  property :created_at, DateTime
  property :updated_at, DateTime
end
get('/~:url') { (url = Url.first(:short=>params[:url])) ? redirect(url.target) : status(404) }
