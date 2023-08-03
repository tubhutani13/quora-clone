module UsersHelper
  def user_profile_picture_link(user)
    user.profile_picture.present? ? rails_blob_path(user.profile_picture.variant(:thumb), disposition: "attachment") : "default.jpeg"
  end

  def user_mini_picture_link(user)
    user.profile_picture.present? ? rails_blob_path(user.profile_picture.variant(:mini), disposition: "attachment") : "default.jpeg"
  end

  def change_password
    current_user.generate_change_password_token
    redirect_to edit_password_url(current_user.password_reset_token)
  end

  def row_class_helper(credit)
    if credit.amount > 0
      row_class = "table-success"
      row_type = "credit"
    else
      row_class = "table-danger"
      row_type = "debit"
    end
    [row_class, row_type]
  end
end
