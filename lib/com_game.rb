# typed: true

require_relative 'user_game'
require_relative 'com_algorithm'

class COMGame < UserGame
  attr_accessor :algorithm

  def initialize
    super
    @algorithm = COMAlgorithm.new
  end

  def create_code
    loop do
      print 'Code: '
      self.code = gets.chomp.downcase.chars
      break if verify_guess(code)
    end

    # Convert colors to pegs
    self.code = code.map { |color| Peg.new(color.to_sym) }
  end

  def take_guess
    increment_round_number
    reset_board

    com_guess = algorithm.play_guess
    puts "Guess #{round_number}: #{com_guess}"

    self.guess = com_guess.chars.map { |color| Peg.new(color.to_sym) }
  end

  def give_feedback
    super
    algorithm.feedback = self.feedback
    puts
  end

  def game_over?
    if feedback[:correct] == 4
      puts "\nCOM Wins!\n"
      return true
    end

    if round_number == 12
      puts "\nCOM Loses\n"
      return true
    end

    false
  end

  def check_result(code, guess)
    reset_board
    self.code = code.chars.map { |color| Peg.new(color.to_sym) }
    self.guess = guess.chars.map { |color| Peg.new(color.to_sym) }

    score_correct_pegs
    score_partial_pegs

    feedback
  end
end
