class Notifier < ActionMailer::Base
  default from: 'info@tech-support.com'

  def success_request(ticket)
    @ticket_path = by_email_tickets_path(ticket.customer_email, only_path: false)
    @receiver_name = ticket.customer_name
    template = render partial: 'success_request'
    mail(to: ticket.customer_email, subject: 'Success request') do |format|
      format.html { template }
    end
  end

  def send_answer_to_customer(ticket)
    @ticket_path = by_email_tickets_path(ticket.customer_email, only_path: false)
    @receiver_name = ticket.customer_name
    @answer = ticket.answer
    template = render partial: 'send_answer'
    mail(to: ticket.customer_email, subject: 'A staff member has replied to your question') do |format|
      format.html { template }
    end
  end
end
