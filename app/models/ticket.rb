class Ticket < ActiveRecord::Base
  belongs_to :staff

  after_create :notify_customer

  def notify_customer
    Notifier.success_request(self).deliver
  end
end
