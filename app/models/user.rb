class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  has_many  :surveys,       class_name: 'Survey',     dependent: :destroy
  has_many  :survey_votes,  class_name: 'SurveyVote', dependent: :destroy
  has_many  :images,        class_name: 'Image',      dependent: :destroy
  has_many  :notes,         class_name: 'Note',      dependent: :destroy
end
