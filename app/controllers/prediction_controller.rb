class PredictionController < ApplicationController
  def by_lat_long
  	@lat = params[:lat].to_f
  	@long = params[:long].to_f
  	@period = params[:period].to_i

    #@predictions_n_probs = [] 
  	@predictions, @probabilities = Prediction.new.predict_by_coordinates(@lat, @long, @period)

  end

  def by_postcode
  	code = params[:post_code].to_i
  	@period = params[:period].to_i

    if Postcode.all.find_by(code_id: code)==nil
        flash[:notice] = "Postcode not available"
    else
    	@postcode = Postcode.all.find_by(code_id: code)
      @all_data = []

      @postcode.locations.each do |location|
        @all_data << [location].concat(Prediction.new.predict_by_coordinates(location.lat, location.long, @period))
      end
    end
  end
end
