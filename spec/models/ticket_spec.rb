require 'rails_helper'

describe Ticket do
  describe 'after create' do
    let(:ticket) { Ticket.create(
        customer_name: 'John',
        customer_email: 'john@example.com',
        question: 'test'
    ) }
    it 'should send email to customer' do
      expect { ticket.notify_customer }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end
  end
end