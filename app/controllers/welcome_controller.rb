require "http"

class WelcomeController < ApplicationController

  def index
    @qd = '{"version" : "0.1","questions": [{"question": "fr-change-of-base","repeat": 5}]}'
    @seed = 'abcd1234'
    @url = 'https://pa-service-prod.herokuapp.com/v1/is_seed_valid?seed=abcd1234'
    @responseJson = HTTP.get(@url).to_s 
  end

end
