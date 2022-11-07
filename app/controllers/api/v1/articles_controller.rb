module Api
  module V1
    class ArticlesController < ApplicationController
      skip_before_action :verify_authenticity_token
      before_action :find_article, only: %i[show update destroy]

      def index
        @articles = Article.order('created_at DESC');
        render json: @articles,status: :ok
      end

      def show
        if @article.nil?
          render json: nil, status: :not_found
        else
          render json: @article, status: :ok
        end
      end

      def create
        article = Article.new(article_params)

        if article.save
          render json:article, status: :ok
        else
          render json: article.errors, status: :unprocessable_entity
        end
      end

      def destroy
        if @article.nil?
          render json: nil, status: :not_found
        else
          @article.destroy
          render json: @article ,status: :ok
        end

      end

      def update
        if @article.nil?
          render json: nil, status: :not_found
        else
          if @article.update_attributes(article_params)
            render json: @article, status: :ok
          else
            render json: @article.errors , status: :unprocessable_entity
          end
        end
      end

      private

      def find_article
        @article = Article.find_by(id: params[:id])
      end

      def article_params
        params.permit(:title, :body)
      end
    end
  end
end
