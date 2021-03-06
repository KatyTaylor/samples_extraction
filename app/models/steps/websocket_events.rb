module Steps::WebsocketEvents
  def self.included(klass)
    klass.instance_eval do
      #after_update :unset_activity_running, if: :can_unset_activity_running?
      #after_update :wss_event
    end
  end

  def can_unset_activity_running?
    (self.kind_of?(Step) && completed? && next_step.nil? && activity)
  end

  def unset_activity_running
    activity.in_progress!
    activity.touch
  end

  def wss_event
    [activity].concat(activities_affected).compact.uniq.each(&:touch)
  end

end
