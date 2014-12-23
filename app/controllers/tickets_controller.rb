class TicketsController < ApplicationController

  before_filter :authenticate_staff!, only: [:unassigned, :answer, :assign]

  def unassigned
    @tickets = Ticket.unassigned + Ticket.assigned_to_staff(current_staff.id)
    respond_to { |format| format.html }
  end

  def by_email
    @tickets = Ticket.by_email(params[:email])
    respond_to { |format| format.html }
  end

  def new
    @ticket = Ticket.new
    respond_to { |format| format.html }
  end

  def create
    @ticket = Ticket.create(ticket_params)
    render :new
  end

  def update
    current_ticket.update_attribute(:question, params[:question])
    render text: :ok
  end

  def answer
    ticket = current_ticket
    ticket.answers.create(text: params[:answer], author: current_staff.full_name)
    ticket.send_answer_to_customer
    render partial: 'ticket_answer', locals: { ticket: ticket }
  end

  def reply
    ticket = current_ticket
    ticket.answers.create(text: params[:message], author: ticket.customer_name)
    ticket.send_reply_to_customer
    ticket.reload
    render partial: 'ticket', locals: { ticket: ticket }
  end

  def close
    ticket = current_ticket
    ticket.close
    render partial: 'ticket', locals: { ticket: ticket }
  end

  def assign
    ticket = current_ticket
    ticket.transaction do
      ticket.update_attributes(staff_id: current_staff.id)
      ticket.open
    end
    render partial: 'ticket_answer', locals: { ticket: ticket }
  end

  private

  def current_ticket
    @ticket ||= Ticket.find(params[:id])
    @ticket.reload
  end

  def ticket_params
    params.require(:ticket).permit(:customer_name, :customer_email, :question, :answer)
  end
end
