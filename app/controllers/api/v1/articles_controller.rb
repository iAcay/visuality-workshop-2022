module Api
  module V1
    class ArticlesController < ApplicationController
      def index
        articles = ArticlesQuery.new(params.permit!).results

        render json: ArticleResource.new(articles).serialize, status: :ok
      end

      def create
        service = CreateArticleService.new(title: params['article']['title'],
                                           content: params['article']['content'])
        if service.call
          render json: ArticleResource.new(service.article).serialize, status: :ok
        else
          render status: :unprocessable_entity
        end
      end
    end
  end
end
