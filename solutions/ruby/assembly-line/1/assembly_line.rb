class AssemblyLine
  CARS_PER_HOUR = 221.0

  def initialize(speed)
    @speed = speed
  end

  def production_rate_per_hour
    cars_per_hour_ideally = @speed * CARS_PER_HOUR
    success_rate = 0
    if 1 <= @speed and @speed <= 4
      success_rate = 1
    elsif @speed <= 8
      success_rate = 0.9
    elsif @speed <= 9
      success_rate = 0.8
    elsif @speed <= 10
      success_rate = 0.77
    end
    cars_per_hour_ideally * success_rate
  end

  def working_items_per_minute
    (production_rate_per_hour / 60.0).to_i
  end
end
