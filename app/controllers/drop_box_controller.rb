class DropBoxController < ApplicationController

  def index
    consumer = Dropbox::API::OAuth.consumer(:authorize)
    request_token = consumer.get_request_token
    session[:request_token] = request_token.token
    session[:request_token_secret] = request_token.secret
    redirect_to request_token.authorize_url(:oauth_callback => 'http://scrooge.dev/drop_box/auth')
  end

  def show
    consumer = Dropbox::API::OAuth.consumer(:authorize)
    request_token = OAuth::RequestToken.new(consumer, session[:request_token], session[:request_token_secret])
    access_token = request_token.get_access_token(:oauth_verifier => params[:oauth_token])
    Dropbox::API::Client.new :token => access_token.token, :secret => access_token.secret
    logger.info '##################'
    logger.info 'token'
    logger.info access_token.token
    logger.info 'secret'
    logger.info access_token.secret
    logger.info '##################'
    redirect_to dashboard_path
  end

# token
# hvdcbruwp4chm6w
# secret
# f8hw3kxt9qjxbmc

end