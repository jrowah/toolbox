defmodule EventSourcedCalculator.V1 do
  # first parameter is the state, second parameter is the command to process
  # iex(1)> EventSourcedCalculator.V1.handle_command(%{value: 22}, %{command: :add, value: 10})
  # %{value: 32}
  def handle_command(%{value: val}, %{command: :add, value: v}) do
    %{value: val + v}
  end

  def handle_command(%{value: val}, %{command: :sub, value: v}) do
    %{value: val - v}
  end

  def handle_command(%{value: val}, %{command: :multiply, value: v}) do
    %{value: val * v}
  end

  def handle_command(%{value: val}, %{command: :divide, value: v}) do
      %{value: val / v}
  end
end
