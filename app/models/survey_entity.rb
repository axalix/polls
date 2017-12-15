class SurveyEntity < ActiveRecord::Base
  include Concerns::Taggable

  belongs_to  :survey,        class_name: 'Survey'
  has_many    :survey_votes,  class_name: 'SurveyVote', dependent: :destroy
  belongs_to  :image,         class_name: 'Image'

  before_save     :survey_must_be_pending
  before_destroy  :survey_must_be_pending

  before_save     :image_should_be_assignable,  :if => Proc.new { |survey_entity| survey_entity.survey.kind == 'photo' }
  after_save      :increase_image_num_refs,     :if => Proc.new { |survey_entity| survey_entity.survey.kind == 'photo' }
  after_destroy   :decrease_image_num_refs,     :if => Proc.new { |survey_entity| survey_entity.survey.kind == 'photo' }

  def survey_must_be_pending
    raise CustomError, 'The survey cannot be changed because it is not pending nor stopped' unless %w(pending stopped).include? survey.status
  end

  def image_should_be_assignable
    Image.assignable(survey.user).find(image_id)
  end

  def increase_image_num_refs
    image.inc_num_refs
  end

  def decrease_image_num_refs
    image.dec_num_refs
  end
end
