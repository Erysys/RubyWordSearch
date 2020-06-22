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

require_relative 'puzzle'

puzzle = Puzzle.new(45,"words.txt", "puzzle.pdf")

puzzle.to_pdf