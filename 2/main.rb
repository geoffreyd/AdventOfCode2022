# frozen_string_literal: true

input = IO.readlines('./input.txt', chomp: true)

# codes = {
#   'A': 'Rock',
#   'B': 'Paper',
#   'C': 'Scissors',
#   'X': 'Rock', # 1
#   'Y': 'Paper', # 2
#   'Z': 'Scissors' # 3
# }

scores = {
  'A X' => 3 + 1, # tie
  'A Y' => 6 + 2, # lose
  'A Z' => 0 + 3, # win
  'B X' => 0 + 1, # win
  'B Y' => 3 + 2, # tie
  'B Z' => 6 + 3, # lose
  'C X' => 6 + 1, # lose
  'C Y' => 0 + 2, # win
  'C Z' => 3 + 3  # tie
}

total_score = input.sum { scores[_1] }

pp total_score
