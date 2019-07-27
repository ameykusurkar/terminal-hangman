require "set"
require "io/console"

DEFAULT_WORD = "recalcitrant".freeze

class Hangman
  def initialize(word = DEFAULT_WORD, lives = 8)
    @word = word.downcase
    @lives = lives
    @guessed_letters = Set.new
  end

  def guess(char)
    char = char.downcase
    return if @guessed_letters.include?(char)

    @guessed_letters << char
    @lives -= 1 unless @word.chars.include?(char)
  end

  def finished?
    @lives.zero? ||
      @word.chars.all? { |c| @guessed_letters.include?(c) }
  end

  def show
    @word.chars.map { |c| @guessed_letters.include?(c) ? c : "_" }.join(" ")
  end

  attr_reader :word, :lives, :guessed_letters
end

def random_word
  File.readlines("/usr/share/dict/words").sample.chomp
rescue Errno::ENOENT
  DEFAULT_WORD
end

def puts_center(str)
  _, width = IO.console.winsize
  puts str.center(width)
end

game = Hangman.new(random_word)

until game.finished?
  system("clear")
  height, _ = IO.console.winsize
  (height/2 - 4).times { puts }
  puts
  puts_center game.show
  puts
  puts_center "#{game.word.length}-letter word. #{game.lives} live(s) left."
  unless game.guessed_letters.empty?
    puts "So far you have tried:"
    puts game.guessed_letters.to_a.sort.join(", ")
  end
  puts "Pick a letter:"

  attempt = gets
  exit unless attempt # EOF
  next unless attempt.match?(/^[A-Za-z]$/)

  game.guess(attempt[0])
end

if game.lives.zero?
  puts "It looks like you lost. The word was \"#{game.word}\"."
else
  puts "\"#{game.word}\""
  puts "Congratulations! You got it!"
end
