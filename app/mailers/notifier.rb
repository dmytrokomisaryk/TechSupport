class Notifier < ActionMailer::Base
  default from: 'info@tech-support.com'

  def success_request(ticket)
    @ticket_path = ticket_path(ticket, only_path: false)
    @receiver_name = ticket.customer_name
    template = render partial: 'success_request'
    mail(to: ticket.customer_email, subject: 'Success request') do |format|
      format.html { template }
    end
  end
end
