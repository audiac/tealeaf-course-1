# blackjack.rb

def calculate_card_total(hand)
  values = hand.map { |card| card[0] }
  total = 0
  values.each do |val|
    if val == 'A'
      total += 11
    elsif val.to_i == 0
      total += 10
    else
      total += val.to_i
    end
  end

  # correct total for aces when over 21
  values.count('A').times do
    total -= 10 if total > 21
  end

  total
end

def has_blackjack?(hand)
  cards = hand.flatten
  if cards.include?('A') && (cards.include?('10') || cards.include?('J') ||
     cards.include?('Q') || cards.include?('K'))
    return true
  end
  false
end

puts "Welcome to Blackjack, what is your name?"
player_name = gets.chomp
puts "Good luck, #{player_name}!"

# create game deck
cards = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A']
suits = ['s', 'c', 'h', 'd']
deck = cards.product(suits)
deck.shuffle!

# deal initial hands, alternating cards
player_cards = []
dealer_cards = []
puts "Dealing cards..."
player_cards << deck.pop
dealer_cards << deck.pop
player_cards << deck.pop
dealer_cards << deck.pop

# check if either player has blackjack
if has_blackjack?(player_cards)
  puts "#{player_name} has Blackjack with #{player_cards}!"
elsif has_blackjack?(dealer_cards)
  puts "Dealer has Blackjack with #{dealer_cards}!"
# if neither player has blackjack, play game
else
  player_hand_total = calculate_card_total(player_cards)
  dealer_hand_total = calculate_card_total(dealer_cards)

  # player turn
  loop do
    puts "Dealer showing: #{dealer_cards[0]}"
    puts "#{player_name}'s hand: #{player_cards}"
    puts "You have #{player_hand_total}."
    puts "\nWould you like to hit or stay? (h/s)"
    hit_or_stay = gets.chomp.downcase

    if hit_or_stay == 'h'
      player_cards << deck.pop
      player_hand_total = calculate_card_total(player_cards)
      if player_hand_total > 21
        puts "#{player_name} busted with #{player_cards}!"
        exit
      end
    else
      puts "#{player_name} chooses to stay."
      break
    end
  end

  # dealer turn
  while dealer_hand_total < 17
    puts "Dealer hits."
    dealer_cards << deck.pop
    dealer_hand_total = calculate_card_total(dealer_cards)
    puts "Dealer has #{dealer_hand_total}."

    if dealer_hand_total > 21
      puts "Dealer busted with #{dealer_cards}"
      puts "You win!"
      exit
    end
  end

  puts "Dealer stays."

  # determine winner
  puts "Dealer has #{dealer_hand_total} with #{dealer_cards}"
  if dealer_hand_total == 21 || (dealer_hand_total > player_hand_total)
    puts "Dealer wins!"
  elsif player_hand_total > dealer_hand_total
    puts "#{player_name} wins!"
  else
    puts "Hands are equal. Push!"
  end
end