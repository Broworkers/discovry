class SearchesController < ApplicationController
  helper_method :current_language

  def index
    if search = params[:place]
      @article = WikipediaSearch.new(current_lang, search)
      @photos  = FlickrSearch.get_photos(search)
    end
  end

  def current_lang
    request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
  end
end
