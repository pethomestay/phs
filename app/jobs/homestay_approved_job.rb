class HomestayApprovedJob
  include SuckerPunch::Job

  # The perform method is in charge of our code execution when enqueued.
  def perform(homestay)
    UserMailer.homestay_approved(homestay).deliver
  end

end
