# prs.rb

# hash of legal game choices
CHOICES = {'p' => 'Paper', 'r' => 'Rock', 's' => 'Scissors'}
puts "Welcome to Paper, Rock, Scissors!"

def display_winning_message(winning_choice, winner)
  case winning_choice
  when 'p'
    puts "Paper wraps Rock!"
    puts "#{winner} won!"
  when 'r'
    puts "Rock smashes Scissors!"
    puts "#{winner} won!"
  when 's'
    puts "Scissors shreds Paper!"
    puts "#{winner} won!"
  end
end

loop do

  # player makes selection
  begin
    puts "Choose one: (P/R/S)"
    player_choice = gets.chomp.downcase
  end until CHOICES.keys.include?(player_choice)

  # computer makes selection
  computer_choice = CHOICES.keys.sample

  # determine winner
  if player_choice == computer_choice
    puts "It's a tie!"
  elsif (player_choice == 'p' && computer_choice == 'r') || (player_choice == 
    'r' && computer_choice == 's') || (player_choice == 's' && 
    computer_choice == 'p')
      display_winning_message(player_choice, "Player")
  else
    display_winning_message(computer_choice, "Computer")
  end

  puts "Play again? (y/n)"
  break if gets.chomp.downcase != 'y'

end

puts "Thanks for playing!"