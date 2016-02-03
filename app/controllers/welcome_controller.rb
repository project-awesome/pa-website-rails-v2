require "http"

class WelcomeController < ApplicationController

  def index

	@qd = '{"version" : "0.1","questions": [{"question": "binHexOctDec","repeat": 5}]}'
    @seed = 'abcd1234'
    request = '{"descriptor:"' + @qd + ', "seed":' + @seed + '}'
    @url = 'https://pa-service-prod.herokuapp.com/v1/build_quiz'
    @responseJson = HTTP.post(@url, :json => {:descriptor => ActiveSupport::JSON.decode(@qd), :seed => @seed}).to_s 
 
  end

end
