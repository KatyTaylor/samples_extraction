class ActivityTypeStepType < ActiveRecord::Base
  belongs_to :activity_type
  belongs_to :step_type
end
