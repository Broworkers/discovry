require 'wikipedia'

class SearchesController < ApplicationController
  def index
    if search = params[:place]
      lang = request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
      Wikipedia.Configure { domain "#{lang}.wikipedia.org" }
      @page = Wikipedia.find(search)
      @content = @page.sanitized_content
    end
  end
end
