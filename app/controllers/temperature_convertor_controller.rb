class TemperatureConvertorController < ApplicationController

  def index
  end

  def convert
    @temp_c = params[:temp_c].to_f
    @temp_f = (@temp_c * 1.8 + 32).round(2)
  end

end
