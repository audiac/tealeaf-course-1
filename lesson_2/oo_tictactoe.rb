class Board
  WINNING_COMBINATIONS = [[1, 2, 3], [4, 5, 6], [7, 8, 9], [1, 5, 9], [3, 5, 7],
                          [1, 4, 7], [2, 5, 8], [3, 6, 9]]

  def initialize
    @data = {}
    (1..9).each { |position| @data[position] = Square.new(' ') }
  end

  def draw
    system 'clear'
    puts " #{@data[1]} | #{@data[2]} | #{@data[3]} "
    puts "---+---+---"
    puts " #{@data[4]} | #{@data[5]} | #{@data[6]} "
    puts "---+---+---"
    puts " #{@data[7]} | #{@data[8]} | #{@data[9]} "
  end

  def all_squares_marked?
    empty_squares.size == 0
  end

  def empty_squares
    squares = @data.select { |_, square| square.empty? }.values
  end

  def empty_positions
    positions = @data.select { |_, square| square.empty? }.keys
  end

  def mark_square(position, marker)
    @data[position].value = marker
  end

  def winning_condition?(marker)
    WINNING_COMBINATIONS.each do |combo|
      return true if @data[combo[0]].value == marker &&
                     @data[combo[1]].value == marker &&
                     @data[combo[2]].value == marker
    end
    false
  end

  def build_combo_hash(combo)
    combo_hash = { combo[0] => @data[combo[0]].value,
                   combo[1] => @data[combo[1]].value,
                   combo[2] => @data[combo[2]].value }
  end

  def two_in_a_row(combinations)
    if combinations.values.count('O') == 2
      combinations.select { |_, v| v == ' ' }.keys.first
    elsif combinations.values.count('X') == 2
      combinations.select { |_, v| v == ' ' }.keys.first
    else
      false
    end
  end

  def win_move
    options = WINNING_COMBINATIONS.select do |combo|
      combo_hash = build_combo_hash(combo)
      two_in_a_row(combo_hash)
    end
    options.flatten!
    positions = options.select { |option| @data[option].empty? }
    positions[0]
  end
end

class Square
  attr_accessor :value

  def initialize(value)
    @value = value
  end

  def empty?
    @value == ' '
  end

  def to_s
    @value
  end
end

class Player
  attr_reader :marker, :name

  def initialize(name, marker)
    @name = name
    @marker = marker
  end
end

class Game
  def initialize
    puts "Please enter your name:"
    name = gets.chomp
    @board = Board.new
    @human = Player.new(name, "X")
    @computer = Player.new("Computer", "O")
    @current_player = @human
  end

  def current_player_marks_square
    if @current_player == @human
      begin
        puts "Choose an empty square (1-9):"
        position = gets.chomp.to_i
      end until @board.empty_positions.include?(position)
    else
      if @board.win_move
        position = @board.win_move
      else
        position = @board.empty_positions.sample
      end
    end
    @board.mark_square(position, @current_player.marker)
  end

  def play
    @board.draw
    loop do
      current_player_marks_square
      @board.draw
      if current_player_win?
        puts "The winner is #{@current_player.name}!"
        break
      elsif @board.all_squares_marked?
        puts "It's a tie!"
        break
      else
        alternate_player
      end
    end
  end

  def current_player_win?
    @board.winning_condition?(@current_player.marker)
  end

  def alternate_player
    if @current_player == @human
      @current_player = @computer
    else
      @current_player = @human
    end
  end
end

Game.new.play