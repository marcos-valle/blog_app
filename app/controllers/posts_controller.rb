class PostsController < ApplicationController
  before_action :set_post, only: %i[ show edit update destroy ]

  # GET /posts or /posts.json
  def index
    if params[:tag_names].present?
      @posts = Post.joins(:tags)
        .where(tags: { name: params[:tag_names] })
        .distinct
        .order(created_at: :desc)
        .page(params[:page])
        .per(3)
    else
      @posts = Post.order(created_at: :desc).page(params[:page]).per(3)
    end
  end

  # GET /posts/1 or /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts or /posts.json
  def create
    @post = Post.new(post_params)

    respond_to do |format|
      if @post.save
        update_tags(@post)
        format.html { redirect_to @post, notice: "Post criado com sucesso." }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        update_tags(@post)
        format.html { redirect_to @post, notice: "Post atualizado com sucesso." }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    @post.destroy!
    respond_to do |format|
      format.html { redirect_to posts_path, status: :see_other, notice: "Post deletado com sucesso." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def post_params
      if current_user
        params[:post][:user_id] = current_user.id
        params[:post][:username] = current_user.username
        params[:tag_names] = update_tags(@post)
      end
      params.require(:post).permit(:title, :content, :user_id, :username)
    end

    def update_tags(post)
      logger.debug "Tags recebidas: #{params[:post][:tags]}"
      tags = params[:tag_names]

      if tags.is_a?(String)
        tags = tags.split(",").map(&:strip).uniq
      elsif tags.is_a?(Array)
        tags = tags.map(&:strip).uniq
      end
      post.tags.clear
      tags.each do |tag|
        post.tags << Tag.find_or_create_by(name: tag)
      end
    end
end
