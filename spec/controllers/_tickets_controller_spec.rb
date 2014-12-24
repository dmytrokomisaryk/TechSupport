require 'rails_helper'

describe TicketsController do

  let(:staff) { Staff.create(
      email: 'john@example.com',
      password: '12345678',
      password_confirmation: '12345678'
  )}
  let!(:ticket) { Ticket.create(
      subject: 'test subject',
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

  describe '#unassigned' do

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

  describe '#update' do
    it 'should change question text' do
      question_text = 'updated question'
      put :update, id: ticket.id, question: question_text
      expect(ticket.reload.question).to eql(question_text)
    end
  end

  describe '#answer' do
    context 'notification' do
      it 'should send answer by email to customer' do
        expect {
          post :answer, id: ticket.id, answer: 'test answer'
        }.to change { ActionMailer::Base.deliveries.count }.by(1)
      end

      it 'should save answer in DB' do
        answer_text = 'test answer'
        post :answer, id: ticket.id, answer: answer_text
        expect(ticket.answers.last.text).to eql(answer_text)
      end
    end
  end

  describe '#reply' do
    context 'notification' do
      before(:each) do
        ticket.update_attribute(:staff_id, staff.id)
      end

      it 'should send reply by email to staff' do
        expect {
          post :reply, id: ticket.id, message: 'test reply'
        }.to change { ActionMailer::Base.deliveries.count }.by(1)
      end

      it 'should save reply in DB' do
        reply_text = 'test reply'
        post :reply, id: ticket.id, message: reply_text
        expect(ticket.answers.last.text).to eql(reply_text)
      end
    end
  end

  describe '#assign' do
    it 'should assign ticket to current_staff' do
      post :assign, id: ticket.id
      expect(ticket.reload.assigned?).to be true
    end
  end

  describe '#close' do
    it 'should be closed' do
      post :close, id: ticket.id
      expect(ticket.reload.closed?).to be true
    end
  end

  describe '#search' do
    it 'should find similar subject' do
      post :search, query: 'subj'
      expect(assigns(:tickets)).to include(ticket)
    end
  end
end