FactoryGirl.define do
  factory :ticket do |ticket|
    ticket.customer_name 'John Smith'
    ticket.customer_email 'johns@example.com'
    ticket.subject 'test subject'
    ticket.question 'test message'
  end
end