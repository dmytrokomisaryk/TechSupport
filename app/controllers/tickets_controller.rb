class TicketsController < ApplicationController

  before_filter :authenticate_staff!, except: [:new, :by_email, :create, :update]

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
    ticket = Ticket.find(params[:id])
    ticket.update_attribute(:question, params[:question])
    render text: :ok
  end

  def answer
    ticket = Ticket.find(params[:id])
    ticket.update_attributes(answer:  params[:answer], staff_id: current_staff.id)
    ticket.send_answer_to_customer
    render text: :ok
  end

  private

  def ticket_params
    params.require(:ticket).permit(:customer_name, :customer_email, :question, :answer)
  end
end
