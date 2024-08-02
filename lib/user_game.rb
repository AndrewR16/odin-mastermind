# typed: false

require_relative 'peg'
require 'colorize'
require 'sorbet-runtime'

# Represents a game of mastermind
class UserGame
  extend T::Sig

  @@COLOR_SELECTION = %i[r o y g b p] # rubocop:disable Naming/VariableName,Style/ClassVars

  attr_accessor :round_number, :feedback, :code, :guess

  def initialize
    @round_number = 0
    @feedback = { correct: 0, partial: 0 }
    @code = []
    @guess = []
  end

  def start_game
    puts "\n/----------------------------/\n\n"
    puts 'Allowed colors: Red, Orange, Yellow, Green, Blue, Purple'

    create_code
    puts 'Hidden colors chosen...'
    # print "For testing: "; code.each { |peg| print "#{peg.color} "}; puts # !Remove after testing
  end

  def create_code
    4.times do
      code.push(Peg.new(@@COLOR_SELECTION[rand(6)]))
    end
  end

  def take_guess # rubocop:disable Metrics/AbcSize
    increment_round_number
    reset_board
    puts

    # Get guess from user and check validity
    guess = T.let([], T::Array[String])
    loop do
      print "Guess #{round_number}: "
      guess = gets.chomp.downcase.chars
      break if verify_guess(guess)
    end

    # Convert colors to pegs
    self.guess = guess.map { |color| Peg.new(color.to_sym) }
  end

  def verify_guess(guess)
    guess.each { |color| return false unless UserGame.color_selection.include?(color.to_sym) }
    return false unless guess.size == 4

    true
  end

  def score_correct_pegs
    guess.each_with_index do |guess_peg, index|
      code_peg = code[index]
      next unless guess_peg.color == code_peg.color

      add_colored_marker
      guess_peg.mark_accounted_for
      code_peg.mark_accounted_for
    end
  end

  def score_partial_pegs
    unaccounted_guess_pegs = guess.reject(&:accounted_for)
    unaccounted_code_pegs = code.reject(&:accounted_for)

    unaccounted_guess_pegs.each do |guess_peg|
      matching_code_peg = unaccounted_code_pegs.find { |code_peg| code_peg.color == guess_peg.color }
      next unless matching_code_peg

      add_white_marker
      guess_peg.mark_accounted_for
      matching_code_peg.mark_accounted_for

      unaccounted_code_pegs.delete(matching_code_peg)
    end
  end

  def give_feedback # rubocop:disable Metrics/AbcSize
    print '...' if feedback[:correct].zero? && feedback[:partial].zero?

    feedback[:correct].times do
      print '(()) '.red
    end

    feedback[:partial].times do
      print '(()) '
    end

    puts
  end

  def game_over?
    if feedback[:correct] == 4
      puts "\nYou Win!\n"
      return true
    end

    if round_number == 12
      puts "\nYou Lose\n"
      puts "Code: #{code.map(&:color).join}"
      return true
    end

    false
  end

  def self.color_selection
    @@COLOR_SELECTION
  end

  def increment_round_number
    @round_number += 1
  end

  def add_colored_marker
    @feedback[:correct] += 1
  end

  def add_white_marker
    @feedback[:partial] += 1
  end

  def reset_board
    @feedback[:correct] = 0
    @feedback[:partial] = 0

    reset_pegs(code)
    reset_pegs(guess)
  end

  def reset_pegs(peg_array)
    peg_array.each(&:reset)
  end
end
