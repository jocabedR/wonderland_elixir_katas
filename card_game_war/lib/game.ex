defmodule CardGameWar.Game do
  # feel free to use these cards or use your own data structure"
  @suits [:spade, :club, :diamond, :heart]
  @ranks [2, 3, 4, 5, 6, 7, 8, 9, 10, :jack, :queen, :king, :ace]
  @cards for suit <- @suits, rank <- @ranks, do: {suit, rank}

  def ranks(), do: @ranks

  defstruct deck_p1: [], deck_p2: []

  def new(n \\ 26)

  def new(n) when n > 0 and n < 27 do
    cards = @cards |> Enum.shuffle() |> Enum.shuffle() |> Enum.shuffle()
    deck_p1 = Enum.take(cards, n)
    deck_p2 = Enum.drop(cards, 26) |> Enum.take(n)
    %__MODULE__{deck_p1: deck_p1, deck_p2: deck_p2}
  end

  def play(%__MODULE__{deck_p1: []}), do: :player2
  def play(%__MODULE__{deck_p2: []}), do: :player1

  def play(
        %__MODULE__{
          deck_p1: [card_p1 | other_cards_p1],
          deck_p2: [card_p2 | other_cards_p2]
        } = game
      ) do
    case round_winner(card_p1, card_p2) do
      :player1 ->
        cards_p1 = other_cards_p1 ++ [card_p1, card_p2]
        play(%{game | deck_p1: cards_p1, deck_p2: other_cards_p2})

      :player2 ->
        cards_p2 = other_cards_p2 ++ [card_p2, card_p1]
        play(%{game | deck_p1: other_cards_p1, deck_p2: cards_p2})

      error ->
        throw(error)
    end
  end

  def round_winner({suit_p1, rank_p1}, {suit_p2, rank_p2})
      when suit_p1 in @suits and
             rank_p1 in @ranks and
             suit_p2 in @suits and
             rank_p2 in @ranks do
    rel_val1 = Enum.find_index(@ranks, &(&1 == rank_p1))
    rel_val2 = Enum.find_index(@ranks, &(&1 == rank_p2))

    cond do
      rel_val1 > rel_val2 ->
        :player1

      rel_val1 < rel_val2 ->
        :player2

      true ->
        suit_rel_val1 = Enum.find_index(@suits, &(&1 == suit_p1))
        suit_rel_val2 = Enum.find_index(@suits, &(&1 == suit_p2))

        cond do
          suit_rel_val1 > suit_rel_val2 -> :player1
          suit_rel_val1 < suit_rel_val2 -> :player2
          true -> {:error, "You can not have the same card."}
        end
    end
  end
end
