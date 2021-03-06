class SearchController < ApplicationController

  skip_authorization_check

  def index
  	if params[:scope]
  		klass = params[:scope]
  		@results = klass.classify.constantize.search(params[:q])
  	else
	    @results = ThinkingSphinx.search(params[:q])
  	end
  end
end
