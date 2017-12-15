class Api::Shared::ImagesController < Api::Controller
  def create
    image = construct_image
    if image.save!
      render json: { id: image.id, resource_url: image.resource_url }, status: :created
    else
      error_response :unprocessable_entity, image.errors
    end
  end

  def show
    image = Image.find(params[:id])
    render json: { id: image.id, resource_url: image.resource_url }, status: :ok
  end

  protected

  def image_params
    i = params.require(:image)
    i.require(:resource)
    i.permit!
  end

  def construct_image
    i  = Image.new(image_params)
    i.user = current_user
    i
  end
end
