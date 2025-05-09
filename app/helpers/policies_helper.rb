module PoliciesHelper
  def policy(record)
    policy_class = "#{record.class}Policy".constantize
    policy_class.new(current_user, record)
  end
end