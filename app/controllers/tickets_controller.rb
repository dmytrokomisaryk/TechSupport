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
    current_ticket.answers.create(text: params[:answer], author: current_staff.full_name)
    current_ticket.send_answer_to_customer
    render partial: 'ticket_answer', locals: { ticket: current_ticket }
  end

  def reply
    current_ticket.answers.create(text: params[:message], author: current_ticket.customer_name)
    current_ticket.send_reply_to_customer
    current_ticket.reload
    render partial: 'ticket', locals: { ticket: current_ticket }
  end

  def close
    current_ticket.close
    render partial: 'ticket', locals: { ticket: current_ticket }
  end

  def assign
    current_ticket.transaction do
      current_ticket.update_attributes(staff_id: current_staff.id)
      current_ticket.assigned
    end
    render partial: 'ticket_answer', locals: { ticket: current_ticket }
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
