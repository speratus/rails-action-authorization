class PostsController < ApplicationController

    def index
        posts = check_authorization(Post.all, current_user)
        render json: posts
    end

    def show
        post = check_authorization(Post.find_by(id: params[:id]), current_user)
        render json: post
    end

    def refuse_index
        posts = check_authorization(Post.all, current_user, behavior: :deny_all)
        render json: posts
    end

    private

    def current_user
        user = User.find_by(id: request.headers['xUser-Id'])
    end
end
