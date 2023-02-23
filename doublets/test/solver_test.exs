defmodule Doublets.SolverTest do
  use ExUnit.Case
  import Doublets.Solver

  test "with word links found" do
    assert ["head", "heal", "teal", "tell", "tall", "tail"] ==
             doublets("head", "tail")

    assert ["door", "boor", "book", "look", "lock"] ==
             doublets("door", "lock")

    assert ["bank", "bonk", "book", "look", "loon", "loan"] ==
             doublets("bank", "loan")

    assert ["wheat", "cheat", "cheap", "cheep", "creep", "creed", "breed", "bread"] ==
             doublets("wheat", "bread")
  end

  test "with no word links found" do
    assert [] == doublets("ye", "freezer")
  end

  test "last_word returns the last word in a list" do
    assert "bread" =
             last_word(["wheat", "cheat", "cheap", "cheep", "creep", "creed", "breed", "bread"])
  end

  test "distance returns the distance between two words" do
    assert 1 = distance("wheat", "cheat")
    assert 4 = distance("head", "tail")
    assert 3 = distance("wheat", "bread")
  end

  test "possible_next returns the all the words with the same length and a distance of 1" do
    assert ["cheat", "cheep"] = possible_next("cheap")
    assert ["creep", "breed"] = possible_next("creed")
  end

  test "complete_seq_variants returns a list of lists where each list contains \"the list\" and one of the variants of the last word of a list that was not in \"the list\"" do
    assert [["creep", "creed", "breed"]] = complete_seq_variants(["creep", "creed"])
  end

  test "find_solution returns a list whose last word is equal to the second argument we sent" do
    assert ["creed", "breed"] = find_solution([["creed", "creep"], ["creed", "breed"]], "breed")
  end
end
