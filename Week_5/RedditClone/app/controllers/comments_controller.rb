class CommentsController < ApplicationController

  def create
    @comment = Comment.new(params["comment"])
    @comment.author_id = current_user.id
    @link = Link.find(params["comment"]["link_id"])
    if @comment.save
      redirect_to sub_link_url(@link.sub, @link)
    else
      flash[:errors] = "You're wrong"
    end
  end

end
