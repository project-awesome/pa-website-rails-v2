require "http"

class WelcomeController < ApplicationController

  def index

  @questionType = params[:questionType] ? params[:questionType] : 'mc'


  @qd = "{\"version\":\"0.1\",\"questions\":[{\"question\":\"#{@questionType}-change-of-base\",\"repeat\":10}]}"
  
  # If there are two parameters in the url
	if params.has_key?(:one) && params.has_key?(:two)
		# If the seed is valid hex (If not valid hex returns random seed)
		if params[:seed].length == 8 && params[:seed] =~ /^[0-9A-F]+$/
			@seed = params[:seed]  	
  	# Otherwise create a random hex seed
		end
	else
		randSeed = ""
	  for i in 0..7
	  	random = Random.rand(15)
			puts random
	  	if random > 9
	  		randSeed += (56+random).chr
	  	else
	  		randSeed += random.to_s
	  	end
	  end
		@seed = randSeed
	end


  @url = 'https://pa-service-prod.herokuapp.com/v1/generate'
  @responseJson = JSON.parse(HTTP.post(@url, :json => {:type => 'json', :qd => ActiveSupport::JSON.decode(@qd), :seed => @seed}).to_s) 

  # Builds up the question HTML
	@questionHTML = "".html_safe
	questions = @responseJson["question"]["questions"]
	for i in 0..(questions.length-1)
		question = questions[i]["question"] 
		@questionHTML += "<p class=\"question\"> #{i+1}. #{question}</p>".html_safe

		if questions[i]["format"] == "multiple-choice"
			@questionHTML += "<ul class=\"answers\">".html_safe
		  	for j in 0..(questions[i]["choices"].length-1)
		  		letter = (97+j).chr
		  		choice = questions[i]["choices"][j]
		  		@questionHTML += "<input type=\"radio\" name=\"q#{i}\" value=\"#{choice}\" data-question-num=\"#{j}\" id=\"q#{i}#{choice}\">#{letter}. <label for=\"q1#{choice}\">#{choice}</label><br/>".html_safe
		  	end
		  	@questionHTML += "</ul>".html_safe
		  	@questionHTML += "<button type=\"button\" id=\"q#{i}_button\">Check Answer</button>".html_safe
		end

		if questions[i]["format"] == "free-response"
			@questionHTML += "<form>Answer:  <input name=\"q#{i}\" id=\"q#{i}\"> <button type=\"button\" id=\"q#{i}_button\">Check Answer</button></form>".html_safe
		end
	end


  end

end
