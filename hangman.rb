require "set"

class Hangman
  def initialize(word="hello", lives=8)
    @word = word
    @lives = lives
    @guessed_letters = Set.new
  end

  def guess(char)
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
  begin
    File.readlines("/usr/share/dict/words").sample.chomp
  rescue
    "recalcitrant"
  end
end

game = Hangman.new(random_word)

until game.finished?
  system("clear")
  puts
  puts game.show
  puts
  puts "#{game.word.length}-letter word. #{game.lives} live(s) left."
  unless game.guessed_letters.empty?
    puts "So far you have tried:"
    puts game.guessed_letters.to_a.sort.join(", ")
  end
  puts "Pick a letter:"

  attempt = gets
  next if attempt.empty? || attempt == "\n" 

  game.guess(attempt[0])
end

if game.lives.zero?
  puts "It looks like you lost. The word was \"#{game.word}\"."
else
  puts "\"#{game.word}\""
  puts "Congratulations! You got it!"
end
