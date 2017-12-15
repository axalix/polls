class Api::Shared::CommentsController < Api::Controller
  def index
    @comments = paginate(scoped_comments, params)
  end

  def create
    prms = comment_params
    @comment = commentable_object.add_comment!(text: prms.try(:[], :text), user: current_user)
    if @comment.errors.empty?
      render status: :created, json: {id: @comment.id}
    else
      error_response :unprocessable_entity, @comment.errors
    end
  end

  def destroy
    @comment = scoped_comments.created_by(current_user).find(params[:comment_id])
    if @comment.deactivate!
      render nothing: true, status: :ok
    else
      error_response :unprocessable_entity, @comment.errors
    end
  end

  protected

  def commentable_object
    objects_types = {
      'survey' => Survey,
      'Survey' => Survey,
    }

    @commentable_object ||= objects_types[params[:type]].active.find(params[:id]) # commentable obj. should have "active" method
  end

  def comment_params
    comment_params = params.require(:comment)
    comment_params.require(:text)
    comment_params.permit([:text])
  end

  def scoped_comments
    commentable_object.comments.visible
  end
end
