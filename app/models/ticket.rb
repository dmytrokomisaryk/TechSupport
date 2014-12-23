class Ticket < ActiveRecord::Base
  include TicketNotifier

  STATUSES = { unassigned: 0, open: 1, on_hold: 2, closed: 3 }

  belongs_to :staff
  has_many :answers, foreign_key: 'ticket_id', class_name: 'TicketAnswer'

  before_validation(on: :create) do
    self.state = STATUSES[:unassigned] if self.state.blank?
  end

  after_create :notify_customer

  scope :order_by_created_at_desc, -> { order('created_at DESC') }
  scope :unassigned, -> {  where(staff_id: nil).order_by_created_at_desc }
  scope :assigned_to_staff, -> (id) { where(staff_id: id).order_by_created_at_desc }
  scope :by_email, -> (email) { where(customer_email: email).order_by_created_at_desc }

  state_machine :state, initial: STATUSES[:unassigned] do
    event :open do
      transition STATUSES[:unassigned] => STATUSES[:open]
    end

    event :close do
      transition [STATUSES[:unassigned], STATUSES[:open]] => STATUSES[:closed]
    end
  end

  def closed?
    state == STATUSES[:closed]
  end

  def assigned?
    staff_id.present?
  end

  def has_answer?
    answers.any?
  end
end
