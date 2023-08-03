module CommentsHandler
  def self.included(klass)
    klass.class_eval do
      has_many :comments, as: :commentable, dependent: :restrict_with_error
    end
  end
end
