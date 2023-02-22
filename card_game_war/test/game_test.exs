defmodule CardGameWar.GameTest do
  use ExUnit.Case
  import CardGameWar.Game

  test "the highest rank wins the cards in the round" do
    assert :player1 == round_winner({:heart, :king}, {:heart, 2})
    assert :player2 == round_winner({:heart, 2}, {:spade, :king})
  end

  test "queens are higher rank than jacks" do
    assert :player1 == round_winner({:heart, :queen}, {:heart, :jack})
  end

  test "kings are higher rank than queens" do
    assert :player2 == round_winner({:heart, :queen}, {:spade, :king})
  end

  test "aces are higher rank than kings" do
    assert :player1 == round_winner({:spade, :ace}, {:spade, :king})
  end

  test "if the ranks are equal, clubs beat spades" do
    assert :player1 == round_winner({:club, :ace}, {:spade, :ace})
  end

  test "if the ranks are equal, diamonds beat clubs" do
    assert :player2 == round_winner({:club, 2}, {:diamond, 2})
  end

  test "if the ranks are equal, hearts beat diamonds" do
    assert :player1 == round_winner({:heart, :jack}, {:diamond, :jack})
  end

  test "the player loses when they run out of cards" do
    game = %CardGameWar.Game{deck_p1: [], deck_p2: [diamond: :queen, spade: 7]}
    assert :player2 = play(game)
  end
end
