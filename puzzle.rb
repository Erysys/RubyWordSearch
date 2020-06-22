############################################################
#
#   Name:           Joel Balmes
#   Assignment:     Final - Word Search
#   Date:           6/9/2019
#   Class:          CIS 283
#   Description:    Generate a Word Search puzzle from a list of words, and print
#                   the puzzle and answer key to a new PDF document.
#
############################################################

require 'prawn'

class Puzzle

  def initialize(size, file, filename)
    @pdf_file = filename
    @size = size
    @key_grid = []
    @puzzle_grid = []
    size.times do
      @key_grid << ("." * size).split("")
      @puzzle_grid << ("." * size).split("")
    end

    words = File.open(file,"r")

    @words_array = []
    until words.eof?
      @words_array << words.gets.chomp.tr(" ","").upcase
    end

    @words_array = @words_array.sort_by{ |word| -word.length }

    @letters_array = []
    @words_array.each do | word |
      word.each_char do | letter |
        if !@letters_array.include?(letter)
          @letters_array << letter
        end
      end
    end

    @words_array.each do | word |
      add_word_to_grid(word)
    end

    row = 0
    until row == size
      col = 0
      until col == size
        if @puzzle_grid[row][col] == "."
          letter = rand((@letters_array.size)-1)
          @puzzle_grid[row][col] = @letters_array[letter]
        end
        col += 1
      end
      row += 1
    end

    @words_array = @words_array.sort

  end

  def add_word_to_grid( word )
    valid_word = false
    until valid_word == true do
      bad_start = ["-1,-1"]
      row = -1
      col = -1
      until !bad_start.include?("#{row},#{col}")
        row = rand(@size-1)
        col = rand(@size-1)
      end

      test_row = row
      test_col = col
      direction = rand(1..8)
      move_x = 0
      move_y = 0

      case direction
      when 1
        move_x = -1
        move_y = 0
      when 2
        move_x = -1
        move_y = 1
      when 3
        move_x = 0
        move_y = 1
      when 4
        move_x = 1
        move_y = 1
      when 5
        move_x = 1
        move_y = 0
      when 6
        move_x = 1
        move_y = -1
      when 7
        move_x = 0
        move_y = -1
      when 8
        move_x = -1
        move_y = -1
      end

      valid_cel = true
        word.each_char do | letter |
          if valid_cel == true && (@key_grid[test_row][test_col] == "." || @key_grid[test_row][test_col] == letter)
            test_row += move_x
            test_col += move_y
            if test_row == -1 || test_row == @size || test_col == -1 || test_col == @size
              bad_start << "#{row},#{col}"
              valid_cel = false
            end
          else
            bad_start << "#{row},#{col}"
            valid_cel = false
          end
        end

      if valid_cel == true
        word.each_char do | letter |
          @key_grid[row][col] = letter
          @puzzle_grid[row][col] = letter
          row += move_x
          col += move_y
        end
        valid_word = true
      end
    end
  end

  def print_puzzle_key
    return_string = ""
    @key_grid.each do | row |
      return_string += row.join(" ") + "\n"
    end
    return return_string
  end

  def print_puzzle
    return_string = ""
    @puzzle_grid.each do | row |
      return_string += row.join(" ") + "\n"
    end
    return return_string
  end

  def print_words
    return_string = ""
    @words_array.each do | word |
      return_string += word + "\n"
    end
    return return_string
  end


  def to_pdf
    puzzle_grid = print_puzzle
    puzzle_words = print_words
    puzzle_key = print_puzzle_key

    Prawn::Document.generate(@pdf_file) do

      font("Helvetica", :size => 37 )
      text "Word Search", :align => :center

      font("Courier", :size => 10)

      puzzle_grid.each_line do | line |
        text line, :kerning => true, :align => :center
      end

      move_down 12
      font("Courier", :size => 14)
      text "Find the following 45 words:", :align => :center
      move_down 12
      font("Courier", :size => 10)

      column_box([50, cursor],:columns => 3,:width => bounds.width) do
        puzzle_words.each_line do |line|
          text line
        end
      end

      start_new_page

      font("Helvetica", :size => 37 )
      text "Answer Key", :align => :center

      font("Courier", :size => 10)


      puzzle_key.each_line do | line |
        text line, :kerning => true, :align => :center
      end

      move_down 12
      font("Courier", :size => 14)
      text "Find the following 45 words:", :align => :center
      move_down 12
      font("Courier", :size => 10)

      column_box([50, cursor],:columns => 3,:width => bounds.width) do
        puzzle_words.each_line do |line|
          text line
        end
      end
    end
  end

end