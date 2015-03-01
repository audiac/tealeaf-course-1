# tictactoe.rb

require 'pry'

WINNING_COMBINATIONS = [[1, 2, 3], [4, 5, 6], [7, 8, 9], [1, 5, 9], [3, 5, 7],
                        [1, 4, 7], [2, 5, 8], [3, 6, 9]]

def initialize_board
  b = {}
  (1..9).each { |position| b[position] = ' '}
  b
end

def draw_board(b)
  system 'clear'
  puts " #{b[1]} | #{b[2]} | #{b[3]} "
  puts "---+---+---"
  puts " #{b[4]} | #{b[5]} | #{b[6]} "
  puts "---+---+---"
  puts " #{b[7]} | #{b[8]} | #{b[9]} "
end

def empty_squares(board)
  board.select { |_, v| v == ' ' }.keys
end

def player_chooses_square(board)
  begin
    puts "Choose an empty square (1-9):"
    player_square = gets.chomp.to_i
  end until board[player_square] == ' '
  board[player_square] = 'X'
end

def computer_chooses_square(board)
  computer_win_move = find_possible_win(board, 'O')
  block_player_win = find_possible_win(board, 'X')
  if computer_win_move
    board[computer_win_move] = 'O'
  elsif block_player_win
    board[block_player_win] = 'O'
  else
    position = empty_squares(board).sample
    board[position] = 'O'
  end
end

def check_winner(board)
  WINNING_COMBINATIONS.each do |combo|
    if board[combo[0]] == 'X' && board[combo[1]] == 'X' && board[combo[2]] == 'X'
      return "Player"
    elsif board[combo[0]] == 'O' && board[combo[1]] == 'O' && board[combo[2]] == 'O'
      return "Computer"
    end
  end
  nil
end

def two_in_a_row(combo, marker)
  if combo.values.count(marker) == 2
    combo.select { |_, v| v == ' '}.keys.first
  else
    false
  end
end

def build_combo_hash(combo, board)
  hash = { combo[0] => board[combo[0]],
           combo[1] => board[combo[1]],
           combo[2] => board[combo[2]] }
end

def find_possible_win(board, marker)
  win_move = WINNING_COMBINATIONS.select do |combo|
    combo_hash = build_combo_hash(combo, board)
    two_in_a_row(combo_hash, marker)
  end
  win_move.flatten!
  winning_square = win_move.select { |square| board[square] == ' ' }
  winning_square[0]
end

board = initialize_board
draw_board(board)

begin
  player_chooses_square(board)
  draw_board(board)
  winner = check_winner(board)
  break if winner
  computer_chooses_square(board)
  draw_board(board)
  winner = check_winner(board)
end until winner || empty_squares(board).empty?

if winner
  puts "#{winner} won!"
else
  puts "It's a tie!"
end