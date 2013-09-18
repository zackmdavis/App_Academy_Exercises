def rps(player_move)
  computer_move = random_move
  winning_moves = { "Rock" => "Scissors", "Scissors" => "Paper", "Paper" => "Rock" }

  if winning_moves[player_move] == computer_move
    outcome = "Win"
  elsif winning_moves[computer_move] == player_move
    outcome = "Lose"
  else
    outcome = "Draw"
  end

  "#{computer_move}, #{outcome}"
end

def random_move
  valid_moves = %w(Rock Paper Scissors)
  valid_moves.shuffle[0]
end