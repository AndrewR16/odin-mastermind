# typed: true

require_relative 'com_game'

class COMAlgorithm
  attr_accessor :possible_codes, :guess, :feedback

  def initialize
    @possible_codes = generate_possible_codes
    @guess = 'rroo'
    @feedback
  end

  def generate_possible_codes
    letters = %w[r o y g b p]
    possible_codes = []

    letters.each do |i|
      letters.each do |j|
        letters.each do |k|
          letters.each do |l|
            possible_codes.push("#{i}#{j}#{k}#{l}")
          end
        end
      end
    end

    possible_codes
  end

  def play_guess
    guess
  end

  def feedback=(response)
    @feedback = response
    determine_next_guess
  end

  def determine_next_guess
    trim_possible_codes
    self.guess = possible_codes.first
  end

  def trim_possible_codes
    code_tester = COMGame.new
    new_possible_codes = []

    possible_codes.each do |possible_code|
      result = code_tester.check_result(possible_code, guess)
      new_possible_codes.push(possible_code) if result == feedback
    end

    self.possible_codes = new_possible_codes
  end
end
