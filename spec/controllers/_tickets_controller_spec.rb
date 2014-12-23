require 'rails_helper'

describe TicketsController do
  describe '#unassigned' do
    let(:staff) { Staff.create(
        email: 'john@example.com',
        password: '12345678',
        password_confirmation: '12345678'
    )}
    let!(:ticket) { Ticket.create(
        question: 'test message',
        customer_email: 'costumer@example.com'
    )}
    let!(:assigned_ticket) { Ticket.create(
        question: 'test message',
        customer_email: 'costumer@example.com',
        state: Ticket::STATUSES[:open],
        staff_id: staff.id
    )}

    before(:each) do
      @request.env['devise.mapping'] = Devise.mappings[:staff]
      sign_in(staff)
      controller.stub(:current_staff){ staff }
    end

    context 'renders the index template' do
      subject { get :unassigned }
      it { expect(subject).to render_template(:unassigned) }
    end

    context 'response unassigned tickets' do
      it 'should render tickets' do
        get :unassigned
        expect(assigns(:tickets)).to eql(Ticket.unassigned + Ticket.assigned_to_staff(staff.id))
      end
    end
  end
end