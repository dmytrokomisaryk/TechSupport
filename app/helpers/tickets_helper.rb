module TicketsHelper
  def format_time(time)
    time.strftime('%a, %u %b %Y %I:%M %p')
  end
end
