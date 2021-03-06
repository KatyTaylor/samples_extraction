class Kit < ActiveRecord::Base
  belongs_to :kit_type
  has_many :activities
  has_one :activity_type, :through => :kit_type

  validates :kit_type, :presence => true
end
