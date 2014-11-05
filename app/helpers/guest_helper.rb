module GuestHelper
  def set_instance_vars
    @unread_count = Mailbox.as_guest(current_user).where(guest_read: false).count
    @awaits_feedback = current_user.bookers.select do |b|
      b.try(:enquiry).try(:feedbacks).try(:blank?) and
      ( b.host_accepted || b.payment.present? ) and
      b.check_in_date < Date.today
    end
    this_month    = Date.today..Date.today.end_of_month
    @upcoming     = current_user.bookers.where(check_in_date: this_month)
                    .order('check_in_date ASC').limit(5)
                    .select('state, check_in_date, check_out_date, bookee_id')
    @upcoming -= @awaits_feedback # Eliminate duplicate bookings
  end
end
