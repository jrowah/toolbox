defmodule DsaEx.Counting.Combinatorics do
  @moduledoc """
  This module provides functions for combinatorial calculations. These are functions that deal with counting, arrangement, and combination of elements. Think of them as ways to answer questions like "How many different ways can I arrange these items?" or "How many ways can I choose a subset from a group?"
  """

  @doc """
  Calculates the factorial of a number (Counts all possible arrangements of n items in order). An example is how many ways you can arrange 5 books in a shelf.

  ## Examples

      iex> DsaEx.Counting.Combinatorics.factorial(0)
      1

      iex> DsaEx.Counting.Combinatorics.factorial(3)
      6

      iex> DsaEx.Counting.Combinatorics.factorial(5)
      120

  """
  # Only matches when the input is exactly 0. This is the base case that stops the recursion by returning 1.
  def factorial(0), do: 1

  # This function matches when the input is a positive integer greater than 0. It calculates the factorial by multiplying the number n by the factorial of (n - 1), effectively reducing the problem size with each recursive call.
  #  factorial(3)
  # Tries clause 1: 3 ≠ 0, so doesn't match
  # Tries clause 2: 3 matches n, and 3 > 0 ✓
  # Returns: 3 * factorial(2)

  # factorial(2)  # Called from above
  # Tries clause 1: 2 ≠ 0, so doesn't match
  # Tries clause 2: 2 matches n, and 2 > 0 ✓
  # Returns: 2 * factorial(1)

  # factorial(1)  # Called from above
  # Tries clause 1: 1 ≠ 0, so doesn't match
  # Tries clause 2: 1 matches n, and 1 > 0 ✓
  # Returns: 1 * factorial(0)

  # factorial(0)  # Called from above
  # Tries clause 1: 0 = 0 ✓ MATCH!
  # Returns: 1
  def factorial(n) when n > 0, do: n * factorial(n - 1)

  def factorial(_), do: raise("Factorial is only defined for non-negative integers.")

  @doc """
  Calculates the number of combinations of n items taken k at a time (n choose k). An example: How many ways can you choose 3 pizza toppings from 10 available?

  ## Examples

      iex> DsaEx.Counting.Combinatorics.combinations(5, 2)
      10

      iex> DsaEx.Counting.Combinatorics.combinations(6, 3)
      20

      iex> DsaEx.Counting.Combinatorics.combinations(10, 3)
      120

  """
  def combinations(n, k) when n >= 0 and k >= 0 do
    factorial(n) / (factorial(k) * factorial(n - k))
  end

  def combinations(_, _), do: raise("Combinations are only defined for non-negative integers.")

  @doc """
  Calculates the number of permutations of n items taken k at a time (nPk).

  ## Examples

      iex> DsaEx.Counting.Combinatorics.permutations(5, 2)
      20

      iex> DsaEx.Counting.Combinatorics.permutations(6, 3)
      120

  """
  def permutations(n, k) when n >= 0 and k >= 0 do
    factorial(n) / factorial(n - k)
  end

  def permutations(_, _), do: raise("Permutations are only defined for non-negative integers.")
end
