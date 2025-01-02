class CommentsController < ApplicationController
  before_action :set_post

  def index
    @comments = @post.comments.order(created_at: :desc)
  end

  def create
    # @post = Post.find(params[:post_id])
    @comment = @post.comments.new(comment_params)

    @comment.user = User.find_by(username: "anônimo")
    # Associa o comentário ao usuário atual
    @comment.user = current_user if user_signed_in?


    if @comment.save
      redirect_to @post, notice: "Comentário adicionado com sucesso!"
    else
      redirect_to @post, alert: "Erro ao adicionar comentário."
    end
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
