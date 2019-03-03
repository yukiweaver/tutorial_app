module AttendancesHelper
  # 出勤、退勤　保存時間
  def current_time
    Time.new(
        Time.now.year,
        Time.now.month,
        Time.now.day,
        Time.now.hour,
        Time.now.min,0)
  end
  
  # 在社時間フォーマット
  def working_times(started_at, finished_at)
    format("%.2f", (((finished_at - started_at) / 60 ) / 60.0))
  end
  
  # 在社時間合計
  def working_times_sum(seconds)
    format("%.2f", seconds / 60 / 60.0)
  end
end
