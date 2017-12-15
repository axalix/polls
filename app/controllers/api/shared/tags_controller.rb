class Api::Shared::TagsController < Api::Controller
  def index
    @tags = paginate(scoped_tags, params)
  end

  def create
    # create tag and rate or unrate
    prms = tag_params
    @tag = taggable_object.rate!(id: prms.try(:[], :id), text: prms.try(:[], :text), user: current_user)
    if @tag.errors.empty?
      render 'show'
    else
      error_response :unprocessable_entity, @tag.errors
    end
  end

  def show
    @tag = taggable_object.tag_by_id(params[:tag_id])
  end

  protected

  def taggable_object
    objects_types = {
      'entity'        => SurveyEntity,
      'SurveyEntity'  => SurveyEntity
    }

    @taggable_object ||= objects_types[params[:type]].find(params[:id])
  end

  def tag_params
    tag_params = params.require(:tag)
    tag_params.require(:text)
    tag_params.permit([:text, :id])
  end

  def scoped_tags
    taggable_object.tags.visible
  end
end
