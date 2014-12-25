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
    if @ticket.errors.blank?
      redirect_to action: :successfully_created, id: @ticket.id
    else
      render action: :new
    end
  end

  def successfully_created; end

  def update
    @ticket = current_ticket
    @ticket.update_attributes(question: params[:question], subject: params[:subject])
    render partial: 'ticket', locals: { ticket: @ticket }
  end

  def answer
    current_ticket.answers.create(text: params[:answer], author: current_staff.full_name)
    current_ticket.send_answer_to_customer
    render partial: 'question', locals: { question: current_ticket.reload }
  end

  def reply
    current_ticket.answers.create(text: params[:message], author: current_ticket.customer_name)
    current_ticket.send_reply_to_customer
    render partial: 'ticket', locals: { ticket: current_ticket.reload }
  end

  def close
    current_ticket.close
    render partial: 'ticket', locals: { ticket: current_ticket.reload }
  end

  def assign
    current_ticket.transaction do
      current_ticket.update_attributes(staff_id: current_staff.id)
      current_ticket.assigned
    end
    render partial: 'question', locals: { question: current_ticket.reload }
  end

  def search
    @tickets = Ticket.search_by_subject(params[:query])
    render partial: 'question', collection: @tickets
  end

  private

  def current_ticket
    @ticket ||= Ticket.find(params[:id])
    @ticket.reload
  end

  def ticket_params
    params.require(:ticket).permit(:customer_name, :customer_email, :subject, :question, :answer)
  end
end
