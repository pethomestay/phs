class HomestayCreatedJob
  include SuckerPunch::Job

  # The perform method is in charge of our code execution when enqueued.
  def perform(homestay)
    UserMailer.homestay_created(homestay).deliver
  end

end
