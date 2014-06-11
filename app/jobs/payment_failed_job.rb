class PaymentFailedJob
  include SuckerPunch::Job

  # The perform method is in charge of our code execution when enqueued.
  def perform(booking,transaction)
    AdminMailer.payment_failure_admin(booking,transaction).deliver
  end

end
