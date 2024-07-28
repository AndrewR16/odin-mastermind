# typed: true

require_relative 'lib/input'
require_relative 'lib/game'

# Run this file to start the program
class Mastermind
  include Input

  def self.run_mastermind
    puts '--- Mastermind ---'
    return unless Input.confirmation?('Start a new game? [y/n]: ')

    start_new_game
  end

  def self.start_new_game
    mastermind_game = Game.new
    mastermind_game.start_game

    # Game loop
    loop do
      mastermind_game.take_guess
      mastermind_game.score_correct_pegs
      mastermind_game.score_partial_pegs
      mastermind_game.give_feedback
      break if mastermind_game.game_over?
    end

    prompt_for_new_game
  end

  def self.prompt_for_new_game
    if Input.confirmation?('New round? [y/n]: ')
      start_new_game
    else
      exit
    end
  end
end

Mastermind.run_mastermind
