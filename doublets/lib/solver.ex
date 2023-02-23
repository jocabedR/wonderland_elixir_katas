defmodule Doublets.Solver do
  @words "./resources/words.txt"
         |> File.stream!()
         |> Enum.to_list()
         |> Enum.map(&String.replace(&1, "\n", ""))

  def doublets(word1, word2) do
    doublets_impl([[word1]], word2)
  end

  def doublets_impl([], _word2), do: []

  def doublets_impl(word_seq, word2) do
    seq_variants = Enum.flat_map(word_seq, fn seq -> complete_seq_variants(seq) end)

    case find_solution(seq_variants, word2) do
      nil -> doublets_impl(seq_variants, word2)
      sol -> sol
    end
  end

  def find_solution(word_seq, target) do
    Enum.find(word_seq, &(last_word(&1) == target))
  end

  def complete_seq_variants(word_seq) do
    variants =
      word_seq
      |> last_word()
      |> possible_next()
      |> Enum.filter(&(&1 not in word_seq))

    for v <- variants, do: word_seq ++ [v]
  end

  def last_word(words), do: Enum.at(words, -1)

  def possible_next(word) do
    Enum.filter(@words, &(String.length(&1) == String.length(word)))
    |> Enum.filter(&(distance(word, &1) == 1))
  end

  def distance(word1, word2) do
    word1_chars = String.graphemes(word1)
    word2_chars = String.graphemes(word2)

    Enum.zip_with(word1_chars, word2_chars, fn x, y -> x != y end)
    |> Enum.count(& &1)
  end
end
