class TicketsController < ApplicationController

  before_filter :authenticate_staff!, except: [:new, :by_email, :create, :update, :close]

  def unassigned
    @tickets = Ticket.unassigned
  end

  def by_email
    @tickets = Ticket.where(customer_email: params[:email])
  end

  def new
    @ticket = Ticket.new
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
    ticket.update_attributes(answer:  params[:answer], staff_id: current_staff.id)
    ticket.send_answer_to_customer
    render text: :ok
  end

  def close
    ticket = current_ticket
    ticket.close
    render partial: 'ticket', locals: { ticket: ticket }
  end

  private

  def current_ticket
    @ticket ||= Ticket.find(params[:id])
  end

  def ticket_params
    params.require(:ticket).permit(:customer_name, :customer_email, :question, :answer)
  end
end
