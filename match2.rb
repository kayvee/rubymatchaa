require 'byebug'

class Card
  attr_accessor :face_up, :value

  def initialize(value)
    @face_up = false
    @value = value
  end

  # def display
  #   # true = up, false = down
  #   # unless self.face_up
  #   #   return self.reveal
  #   # else
  #   #   self.hide
  #   # end
  #
  #   return self.hide unless self.face_up
  #   self.reveal
  # end

  def reveal
    @face_up = true
  end

  def hide
    @face_up = false
  end

  def to_s
    if self.face_up
      @value.to_s
    else
      "_"
    end
  end

  def ==(prev_guess)
    @value == prev_guess.value
  end

  # Works the same ? as def hide
  # def hide2
  #    self.face_up = true
  # end
  #
  # Does not work; only local change
  # def hide3
  #    face_up = true
  # end

end

class Board

  attr_accessor :grid, :guessed_pos, :col, :row

  def initialize(row, col)
    @row = row
    @col = col
    @grid = Array.new(@row) {Array.new(@col)}
    self.populate
  end

  def populate
    cards = []
    ((@row * @col)/2).times do |n|
      cards.push(Card.new(n), Card.new(n))
    end
    cards.shuffle!

    @grid.each_with_index do |row, r|
      row.each_with_index do |col, c|
        @grid[r][c] = cards.pop
      end
    end
  end

  #Possible way to use Array#to_s in conjunction with Card#to_s
  def render
    @grid.each_with_index do |row, r|
      print "\n"
      row.each_with_index do |col, c|
        print @grid[r][c].to_s + " "
      end
    end
  end

  # def [](pos)
  #   @grid[pos[0]][pos[1]]
  # end

  def reveal(r, c)
    if @grid[r][c].face_up
      puts "already shown"
    else
      @grid[r][c].reveal
      self.render
    end
    @grid[r][c].value
  end

  #any? or all? chance
  def won?
    @grid.each_with_index do |row, r|
      row.each_with_index do |col, c|
        if @grid[r][c].to_s == '_'
          return false
        end
      end
      true
    end
  end

end

class Game
  attr_accessor :board, :prev_guess, :player

  def initialize(row, col)
    @board = Board.new(row, col)
    @prev_guess = false # look at this later
    make_player
    @board.render
    play
  end

  def make_player
    puts "human or computer"
    input = gets.chomp
    if input == 'human'
      @player = HumanPlayer.new
    elsif input == 'computer'
      @player = ComputerPlayer.new(@board.row, @board.col)
    else
      input = make_player
    end
  end

  def play
    until over
      puts "\n please make guess as coords. ex/ '1 2'"
      pos = @player.get_input
      # pos = gets().chomp
      make_guess(pos)
    end

    puts "You win!"
  end

  def make_guess(pos)
    r = pos[0].to_i - 1
    c = pos[2].to_i - 1
    @board.reveal(r, c)
    if @prev_guess
      check_pair(@prev_guess, @board.grid[r][c])
    else
      @prev_guess = @board.grid[r][c]
    end
  end

  def check_pair(prev_guess, current_guess)
    unless prev_guess == current_guess
      current_guess.hide
      prev_guess.hide
    end
    @prev_guess = false
  end

    # unless @board.grid[r][c] == @prev_guess #use .==(@prev_guess) ?
    #   @board.grid[r][c].hide
    #   @prev_guess.hide
    # end

  def over
    @board.won?
  end

end

class HumanPlayer
  def get_input
    pos = gets().chomp
  end
end

class ComputerPlayer
  attr_accessor :pos_val

  def initialize(row, col)
    @pos_val = Hash.new
    @row = row + 1
    @col = col + 1
  end

  def get_input #guess
    # guess =
    # guess
  end

  def rand_guess
    r = rand(1..@row)
    c = rand(1..@col)
  end

end
