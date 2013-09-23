white_pieces = {"white king" => "\u2654", "white queen" => "\u2655",
  "white rook" => "\u2656", "white bishop" => "\u2657",
  "white knight" => "\u2658", "white pawn" => "\u2659"}
black_pieces = {"black king" => "\u265A", "black queen" => "\u265B",
  "black rook" => "\u265C", "black bishop" => "\u265D",
  "black knight" => "\u265E", "black pawn" => "\u265F"}

[white_pieces, black_pieces].each do |set|
  set.each do |piece, symbol|
    print piece, " ", symbol, "\n"
  end
end
