class TicketsController < ApplicationController
  def new
    @ticket = Ticket.new
  end

  def create
    @ticket = Ticket.create(ticket_params)
    render :new
  end

  private

  def ticket_params
    params.require(:ticket).permit(:customer_name, :customer_email, :message)
  end
end
