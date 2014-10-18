require 'wikipedia'

class SearchesController < ApplicationController
  def index
    if search = params[:place]
      Wikipedia.Configure { domain 'pt.wikipedia.org' }
      @page = Wikipedia.find(search)
      @content = WikiCloth::Parser.new(data: @page.content).to_html
    end
  end
end
