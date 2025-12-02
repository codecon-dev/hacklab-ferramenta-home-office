class GenerateWeeklyReportsJob
  @queue = :reports

  def self.perform(week_start_str = nil, week_end_str = nil)
    today = Date.current

    week_start = if week_start_str
                   Date.parse(week_start_str)
                 else
                   (today - 7.days).beginning_of_week(:monday)
                 end

    week_end = if week_end_str
                 Date.parse(week_end_str)
               else
                 week_start.end_of_week(:sunday)
               end

    WeeklyReports::GenerateForPeriod.call(
      week_start: week_start,
      week_end:   week_end
    )
  end
end
