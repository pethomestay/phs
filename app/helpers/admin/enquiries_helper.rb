module Admin::EnquiriesHelper

  def homestay_feedback_params(enquiry)
    {feedback: {enquiry_id: enquiry.id, user_id: enquiry.user.id, subject_id: enquiry.homestay.user.id}}
  end

  def owner_feedback_params(enquiry)
    {feedback: {enquiry_id: enquiry.id, user_id: enquiry.homestay.user.id, subject_id: enquiry.user.id}}
  end

  def feedback_for_homestay_label(enquiry)
    if enquiry.feedback_for_homestay?
      rating_stars(enquiry.feedback_for_homestay.rating)
    else
      haml_tag :span, 'none'
      haml_concat(link_to 'Provide feedback to homestay',
                  new_admin_feedback_path(homestay_feedback_params(@enquiry)),
                  class: 'btn btn-primary')
    end
  end

  def feedback_for_owner_label(enquiry)
    if enquiry.feedback_for_owner?
      rating_stars(enquiry.feedback_for_owner.rating)
    else
      haml_tag :span, 'none'
      haml_concat(link_to 'Provide feedback to pet owner',
                  new_admin_feedback_path(owner_feedback_params(@enquiry)),
                  class: 'btn btn-primary')
    end
  end
end
