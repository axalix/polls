class DatingSite < ActiveRecord::Base

  scope :active,  -> { where(status: :active) }
  scope :visible, -> { where(status: [:active]) }
end
