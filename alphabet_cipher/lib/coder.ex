defmodule AlphabetCipher.Coder do
  @alphabet ?a..?z |> Enum.to_list() |> List.to_string()
  @alphabet_elem String.graphemes(@alphabet)

  def create_tuples(keyword, message) do
    len = (String.length(message) / String.length(keyword)) |> ceil()
    keyword = String.duplicate(keyword, len)

    Enum.zip(String.graphemes(keyword), String.graphemes(message))
  end

  def encode(keyword, message) do
    letter_tuples = create_tuples(keyword, message)

    Enum.map(letter_tuples, fn {k_letter, m_letter} ->
      Map.get(encoding_table(), m_letter)
      |> Enum.at(Enum.find_index(@alphabet_elem, fn x -> x == k_letter end))
    end)
    |> List.to_string()
  end

  def decode(keyword, message) do
    letter_tuples = create_tuples(keyword, message)

    Enum.map(letter_tuples, fn {k_letter, m_letter} ->
      Enum.reduce(encoding_table(), [], fn {k, v}, acc ->
        idx = Enum.find_index(@alphabet_elem, fn x -> x == k_letter end)
        Enum.at(v, idx)

        if Enum.at(v, idx) == m_letter do
          acc ++ [k]
        else
          acc ++ []
        end
      end)
    end)
    |> List.to_string()
  end

  def decipher(cipher, message) do
    letter_tuples = create_tuples(cipher, message)

    Enum.map(letter_tuples, fn {c_letter, m_letter} ->
      table = Map.get(encoding_table(), m_letter)
      idx = Enum.find_index(table, fn x -> x == c_letter end)
      Enum.at(@alphabet_elem, idx)
    end)
    |> treatDecipher()
  end

  def treatDecipher(word_chars, n \\ 1)

  def treatDecipher(word_chars, n) do
    {h, t} = Enum.split(word_chars, n)
    {th, _} = Enum.split(t, n)

    if h == th do
      List.to_string(h)
    else
      treatDecipher(word_chars, n + 1)
    end
  end

  @encoding_table Enum.reduce(@alphabet_elem, %{}, fn letter, table ->
                    idx = Enum.find_index(@alphabet_elem, fn l -> l == letter end)
                    {l1, l2} = Enum.split(@alphabet_elem, idx)
                    new_alphabet = l2 ++ l1
                    Map.put(table, letter, new_alphabet)
                  end)

  def encoding_table, do: @encoding_table
end
