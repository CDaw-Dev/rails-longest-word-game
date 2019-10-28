require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    session[:score] = session[:score] || 0
    @letters = 10.times.map { ('A'..'Z').to_a.sample }
  end

  def score
    attempt = params[:word]
    grid = params[:letter]
    return reset if attempt == "reset!"

    @answer = "Sorry but #{attempt} can't be build out of #{grid}" unless letter_checker?(attempt, grid)
    validation = word_verification(attempt)
    if validation["found"]
      @answer = "Congratulations #{attempt} is a valid English word!"
      session[:score] += attempt.length
      @score = session[:score]
    else
      @answer = "Sorry but #{attempt} does not seems to be a valid English word..."
    end
  end

  def letter_checker?(attempt, grid)
    attempt_test = attempt.upcase.chars
    attempt_test.all? { |word| grid.count(word) >= attempt_test.count(word) }
  end

  def word_verification(attempt)
    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    serialized_beers = open(url).read
    validation = JSON.parse(serialized_beers)
    validation
  end

  def reset
    session[:score] = 0
  end
end
