module TicketsHelper
  def format_time(time)
    time.strftime('%a, %e %b %Y %I:%M %p')
  end
end
