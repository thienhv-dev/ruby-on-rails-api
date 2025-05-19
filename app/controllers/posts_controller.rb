class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: [:show, :update, :destroy]

  # GET /posts
  def index
    posts_query = Post.ransack(params[:q])

    posts = posts_query.result.includes(:user)

    render json: posts, each_serializer: PostSerializer, status: :ok
  end

  # GET /posts/:id
  def show
    render json: @post, serializer: PostSerializer, status: :ok
  end

  # POST /posts
  def create
    @post = current_user.posts.create!(post_params)
    render json: @post, serializer: PostSerializer, status: :created, location: @post
  end

  # PATCH/PUT /posts/:id
  def update
    @post.update!(post_params)
    render json: @post, serializer: PostSerializer, status: :ok
  end

  # DELETE /posts/:id
  def destroy
    @post.destroy
    head :no_content
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_post
    @post = Post.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def post_params
    params.require(:post).permit(:title, :content)
  end
end
