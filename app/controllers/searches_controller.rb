class SearchesController < ApplicationController
  before_action :authenticate_user!

	def search
		@model = params[:model]
		@content = params[:content]
		@method = params[:method]
		if @model == 'user'
			results = User.search_for(@content, @method)
		elsif @model == 'post'
			results = Post.search_for(@content, @method)
		elsif @model == 'tag'
			results = Tag.search_posts_for(@content, @method)
		end
		@results = results.page(params[:page]).per(20)
	end
end
