module GuestHelper
  def set_instance_vars
    @unread_count = Mailbox.as_guest(current_user).where(guest_read: false).count
    @awaits_feedback = current_user.bookers.sort_by(&:check_in_date).select {|b| b.check_out_date < Date.today && b.try(:enquiry).try(:feedbacks).try(:empty?) && view_context.translate_state(b.state) == 'Booked' }
    @upcoming = current_user.bookers.sort_by(&:check_in_date).select {|b| b.check_out_date >= Date.today}
  end
end
