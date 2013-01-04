class DropBoxController < ApplicationController
  
  def index
    consumer = Dropbox::API::OAuth.consumer(:authorize)
    request_token = consumer.get_request_token
    session[:request_token] = request_token.token
    session[:request_token_secret] = request_token.secret
    redirect_to request_token.authorize_url(:oauth_callback => Scrooge::Application.config.redirect_url)
  end

  def show
    consumer = Dropbox::API::OAuth.consumer(:authorize)
    request_token = OAuth::RequestToken.new(consumer, session[:request_token], session[:request_token_secret])
    access_token = request_token.get_access_token(:oauth_verifier => params[:oauth_token])
    Dropbox::API::Client.new :token => access_token.token, :secret => access_token.secret
    redirect_to dashboard_path
  end
end