class PostPolicy
  def initialize(user, post)
    @user = user
    @post = post
  end
  
  def can_edit?
    owner? || admin?
  end
  
  def can_destroy?
    owner? || admin?
  end
  
  private
  
  def owner?
    @user.present? && @post.user_id == @user.id
  end
  
  def admin?
    @user.present? && @user.admin?
  end
end