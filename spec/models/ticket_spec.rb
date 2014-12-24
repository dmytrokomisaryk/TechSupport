require 'rails_helper'

describe Ticket do
  describe 'after create' do
    let(:ticket) { FactoryGirl.create(:ticket) }
    it 'should send email to customer' do
      expect { ticket }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end
  end
  
  describe 'validation' do

    it 'should require customer_name' do
      ticket = FactoryGirl.build(:ticket, customer_name: nil)

      expect(ticket).to_not be_valid
      expect(ticket.errors.keys).to include(:customer_name)
    end

    it 'should require customer_email' do
      ticket = FactoryGirl.build(:ticket, customer_email: nil)

      expect(ticket).to_not be_valid
      expect(ticket.errors.keys).to include(:customer_email)
    end

    it 'should require subject' do
      ticket = FactoryGirl.build(:ticket, subject: nil)

      expect(ticket).to_not be_valid
      expect(ticket.errors.keys).to include(:subject)
    end

    it 'should require question' do
      ticket = FactoryGirl.build(:ticket, question: nil)

      expect(ticket).to_not be_valid
      expect(ticket.errors.keys).to include(:question)
    end
  end
end