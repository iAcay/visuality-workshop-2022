module Api
  module V1
    class ArticlesController < ApplicationController
      def index
        articles = ArticlesQuery.new(params.permit!).results

        render json: ArticleResource.new(articles).serialize, status: :ok
      end
    end
  end
end
