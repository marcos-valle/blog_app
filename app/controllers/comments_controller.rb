class CommentsController < ApplicationController
  before_action :set_post

  def create
    # @post = Post.find(params[:post_id])
    @comment = @post.comments.new(comment_params)

    @comment.user = current_user if user_signed_in?
    # Associa o comentário ao usuário atual

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
