class PagesController < ApplicationController
  def home
  end

  def new
    @letters = (0...10).map { (65 + rand(26)).chr }
    flash[:letters] = @letters
  end

  def score
    @letters = flash[:letters]
    if params[:name]
      @name = params[:name]
    end

    @input = ''
    if params[:input]
      @input = params[:input]
    end
    @answer = @input.upcase.split('')

    unless @input == ''
      @result_letters = 'Success'
      i = @answer.length - 1
      if i.positive?
        if @letters.include? @answer[i]
          @letters.slice!(@letters.index(@answer[i]))
        else
          @result_letters = 'Error'
        end
        i -= 1
      end

      english = open("https://wagon-dictionary.herokuapp.com/#{@input}")
      json = JSON.parse(english.read)
      @result_english = json['found'] ? 'Success' : 'Error'

      @time = Time.now
      @score = 0
      @message = ''
      if @result_letter == 'Error' && @result_english == 'Error'
        @message = "Sorry #{@name.capitalize} but #{@input.upcase} can\'t be built out of the random letters and #{@input} does not seem to be a valid English word"
      elsif @result_letter == 'Error'
        @message = "Sorry #{@name.capitalize} but #{@input.upcase} can\'t be built out of the random letters"
      elsif @result_english == 'Error'
        @message = "Sorry #{@name.capitalize} but #{@input.upcase} does not seem to be a valid English word"
      else
        @message = "Congratulations #{@name.capitalize}! #{@input.upcase} is a valid English word and can be built out of the random letters"
        @score = @answer.length
        @message_score = "Your score is #{@score}"
      end
      @names.nil? ? @names = "[#{@name}]" : @names << @name
      @scores.nil? ? @scores = "[#{@score}]" : @scores << @score.to_s
    end
  end
end
