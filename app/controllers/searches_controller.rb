require 'wikipedia'

class SearchesController < ApplicationController
  def index
    if search = params[:place]
      #Wikipedia.Configure { domain 'pt.wikipedia.org' }
      @page = Wikipedia.find(search)
      @content = @page.sanitized_content
    end
  end
end
