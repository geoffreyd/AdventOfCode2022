# frozen_string_literal: true

input = IO.readlines('./input.txt', chomp: true)

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

####### Part 2

real_scores = {
  'A X' => 0 + 3,
  'A Y' => 3 + 1,
  'A Z' => 6 + 2,
  'B X' => 0 + 1,
  'B Y' => 3 + 2,
  'B Z' => 6 + 3,
  'C X' => 0 + 2,
  'C Y' => 3 + 3,
  'C Z' => 6 + 1
}
total_real_score = input.sum { real_scores[_1] }

pp total_real_score
