class Game
  attr_accessor :player, :dealer, :deck
  HAND_LIMIT = 21
  DEALER_MINIMUM = 17

  def initialize
    self.player = Player.new(get_player_name)
    self.dealer = Player.new("Dealer")
    self.deck = Deck.new
  end

  def get_player_name
    puts "Welcome to Blackjack!"
    puts "What is your name?"
    player_name = gets.chomp
  end

  def play
    deal_opening_hand
    if dealer.has_blackjack?
      show_winning_message_and_exit(dealer)
    elsif player.has_blackjack?
      show_winning_message_and_exit(player)
    else
      show_flop
    end

    player_turn
    show_busted_message_and_exit(player) if player.busted?
    dealer_turn
    show_busted_message_and_exit(dealer) if dealer.busted?
    compare_hands
  end

  def deal_opening_hand
    2.times do
      player.hand << deck.deal_card
      dealer.hand << deck.deal_card
    end
  end

  def show_winning_message_and_exit(winner)
    puts "#{winner.name} has Blackjack!"
    exit
  end

  def show_flop
    puts "Dealer is showing #{dealer.hand[0]}"
    puts "Your cards: "
    player.hand.each { |card| puts card }
  end

  def player_turn
    loop do
      puts "Would you like to hit or stay ('h' / 's')?"
      hit_or_stay = gets.chomp
      player.hand << deck.deal_card if hit_or_stay == 'h'
      show_flop
      break if player.busted? || hit_or_stay != 'h'
    end
  end

  def dealer_turn
    while dealer.card_total < DEALER_MINIMUM
      dealer.hand << deck.deal_card
      puts "Dealer hits!"
    end
    puts "Dealer stays."
  end

  def compare_hands
    if dealer.card_total > player.card_total
      puts "Dealer won with #{dealer.card_total}"
      puts "You had #{player.card_total}"
    elsif dealer.card_total < player.card_total
      puts "You won with #{player.card_total}"
      puts "Dealer had #{dealer.card_total}"
    else
      puts "It's a tie!"
    end
  end

  def show_busted_message_and_exit(loser)
    puts "#{loser.name} busted with #{loser.card_total}!"
    exit
  end
end

class Player
  attr_accessor :name, :hand

  def initialize(name)
    self.name = name
    self.hand = []
  end

  def has_blackjack?
    values = hand.collect { |card| card.value }
    if values.include?('A') && (values.include?('10') || values.include?('J') ||
       values.include?('Q') || values.include?('K'))
      return true
    else
      return false
    end
  end

  def card_total
    values = hand.collect { |card| card.value }
    total = 0
    values.each do |value|
      if value == 'A'
        total += 11
      elsif value.to_i == 0
        total += 10
      else
        total += value.to_i
      end
    end

    # correct total for aces when over 21
    values.count('A').times do
    total -= 10 if total > Game::HAND_LIMIT
  end

  total
  end

  def busted?
    card_total > Game::HAND_LIMIT
  end
end

class Card
  attr_accessor :value, :suit

  def initialize(card)
    self.value = card[0]
    self.suit = card[1]
  end

  def to_s
    "#{value}#{suit}"
  end
end

class Deck
  attr_accessor :cards, :values, :suits

  def initialize
    self.cards = []
    self.values = ['2', '3', '4', '5', '6', '7', '8', '9', '10',
                   'J', 'Q', 'K', 'A']
    self.suits = ['s', 'c', 'h', 'd']
    values.each do |value|
      suits.each do |suit|
        cards << Card.new([value, suit])
      end
    end
    cards.shuffle!
  end

  def deal_card
    cards.pop
  end
end

Game.new.play