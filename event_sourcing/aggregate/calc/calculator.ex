defmodule Calculator do
  def add(a, b) do
    a + b
  end

  def sub(a, b) do
    a - b
  end

  def multiply(a, b) do
    a * b
  end

  def divide(a, b) do
    if b == 0 do
      {:error, "Cannot divide by zero"}
    else
      a / b
    end
  end
end
