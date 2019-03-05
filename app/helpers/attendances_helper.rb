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
  
  # users#show @first_dayに使用
  # 三項演算子使用　if文 ? true : false
  def first_day(date)
    !date.nil? ? Date.parse(date) : Date.current.beginning_of_month
  end
  
  def user_attendances_month_date
    @user.attendances.where('worked_on >= ? and worked_on <= ?', @first_day, @last_day).order('worked_on')
  end
end
