# Blackjack is a game played between a human player and a computer player. Each
# player is dealt two cards from a deck (alternating) at the beginning. Both players
# check to see if they have Blackjack. If neither does, the human chooses whether to
# take another card (hit) or stay with the cards they have. The computer hits if
# they have less than 17 and stays if they have 17 or greater. After both players
# stay, the cards are compared and whoever has a higher total wins the game. If at
# any time a player's cards total more than 21, that player has "busted" and loses
# the game.

# Game
# - play
# - determine_winner

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
      true
    else
      false
    end
  end

# - busted?
end

# Human
# - hit_or_stay

# Dealer
# - hit_or_stay

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