class QuarterObserver < ActiveRecord::Observer
  def after_save(quarter)
    if quarter.current_changed? && quarter.current
      Quarter.update_all("current=FALSE", "id <> #{quarter.id}")
    end
  end
end
