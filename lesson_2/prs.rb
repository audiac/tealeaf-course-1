class Hand
  include Comparable

  attr_reader :value

  def initialize(choice)
    @value = choice
  end

  def <=>(other_hand)
    if @value == other_hand.value
      0
    elsif (@value == 'p' && other_hand.value == 'r') ||
          (@value == 'r' && other_hand.value == 's') ||
          (@value == 's' && other_hand.value == 'p')
      1
    else
      -1
    end
  end

  def display_winning_message
    case @value
    when 'p'
      puts "Paper wraps Rock!"
    when 'r'
      puts "Rock smashes Scissors!"
    when 's'
      puts "Scissors shreds Paper!"
    end
  end
end

class Player
  attr_accessor :hand
  attr_reader   :name

  def initialize(name)
    @name = name
  end
end

class Human < Player

  def pick_hand
    begin
      puts "Choose one: (P/R/S)"
      choice = gets.chomp.downcase
    end until Game::CHOICES.keys.include?(choice)

    self.hand = Hand.new(choice)
  end
end

class Computer < Player

  def pick_hand
    self.hand = Hand.new(Game::CHOICES.keys.sample)
  end
end

class Game
  attr_reader :player, :computer

  CHOICES = {'p' => 'Paper', 'r' => 'Rock', 's' => 'Scissors'}

  def initialize
    puts "What is your name?"
    player_name = gets.chomp
    @player = Human.new(player_name)
    @computer = Computer.new('Computer')
  end

  def compare_hands
    if player.hand == computer.hand
      puts "It's a tie!"
    elsif player.hand > computer.hand
      player.hand.display_winning_message
      puts "#{player.name} won!"
    else
      computer.hand.display_winning_message
      puts "#{computer.name} won!"
    end
  end

  def play
    player.pick_hand
    computer.pick_hand
    compare_hands
  end
end

loop do
  game = Game.new.play
  puts "Would you like to play again?"
  play_again = gets.chomp.downcase
  break if play_again != 'y'
end