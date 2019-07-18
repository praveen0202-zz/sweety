class BloodGlucoseLevelsController < ApplicationController

  def index
    @blood_glucose_levels = BloodGlucoseLevel.filter(params)
    reading_minmax
  end

  def new
    @blood_glucose_level = BloodGlucoseLevel.new(reading_time: Time.current)
  end

  def create
    @blood_glucose_level = BloodGlucoseLevel.new(blood_glucose_level_params)
    if @blood_glucose_level.save
      @blood_glucose_levels = BloodGlucoseLevel.where("reading_time >= ?", Date.current)
      reading_minmax
    end
  end

  def reading_minmax
    glucose_levels = @blood_glucose_levels.map(&:glucose_level)
    @min_reading, @max_reading = glucose_levels.minmax
    @average_reading = glucose_levels.count == 0 ? '' : glucose_levels.sum/glucose_levels.count
  end

  private

  def blood_glucose_level_params
    params.require(:blood_glucose_level).permit(:reading_time, :glucose_level)
  end

end