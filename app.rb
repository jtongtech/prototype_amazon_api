require 'sinatra'
require 'aws-flow'


OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

load './local_env.rb' if File.exist?('./local_env.rb')

set :AWS_ACCESS_KEY_ID, ENV['AWS_ACCESS_KEY_ID']
set :AWS_SECRET_ACCESS_KEY, ENV['AWS_SECRET_ACCESS_KEY']

def authorize()
  redirect '/' if !(session[:email])
end

def subscribe()
  redirect '/' if !(session[:subscribed])
end