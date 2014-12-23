module TicketNotifier
  def send_answer_to_customer
    Notifier.send_answer_to_customer(self).deliver
  end

  def send_reply_to_customer
    Notifier.send_reply_to_customer(self).deliver
  end

  private

  def notify_customer
    Notifier.success_request(self).deliver
  end
end