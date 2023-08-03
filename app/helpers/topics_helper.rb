module TopicsHelper
  def topics_list
    Topic.pluck(:name)
  end
end
