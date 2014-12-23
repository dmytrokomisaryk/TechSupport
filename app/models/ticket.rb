class Ticket < ActiveRecord::Base
  STATUSES = { unassigned: 0, open: 1, on_hold: 2, closed: 3 }

  belongs_to :staff

  before_validation(on: :create) do
    self.state = STATUSES[:unassigned] if self.state.blank?
  end

  after_create :notify_customer

  scope :unassigned, -> {  where(staff_id: nil) }

  def send_answer_to_customer
    Notifier.send_answer_to_customer(self).deliver
  end

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

  private

  def notify_customer
    Notifier.success_request(self).deliver
  end
end
