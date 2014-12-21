class Ticket < ActiveRecord::Base
  belongs_to :staff

  after_create :notify_customer

  scope :unassigned, -> {  where(staff_id: nil) }

  def send_answer_to_customer
    Notifier.send_answer_to_customer(self).deliver
  end

  private

  def notify_customer
    Notifier.success_request(self).deliver
  end
end
