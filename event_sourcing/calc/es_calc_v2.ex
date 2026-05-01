defmodule EventSourcedCalculator.V2 do
  # first parameter is the state, second parameter is the command to process
  # iex(1)> EventSourcedCalculator.V1.handle_command(%{value: 22}, %{command: :add, value: 10})
  # %{value: 10, event_type: :value_added}
  # iex(8)> EventSourcedCalculator.V2.handle_event(%{value: 22}, event)
  # %{value: 32}
  def handle_command(%{value: _val}, %{command: :add, value: v}) do
    %{event_type: :value_added, value: v}
  end

  def handle_command(%{value: _val}, %{command: :sub, value: v}) do
    %{event_type: :value_subtracted, value: v}
  end

  def handle_command(%{value: _val}, %{command: :multiply, value: v}) do
    %{event_type: :value_multiplied, value: v}
  end

  def handle_command(%{value: _val}, %{command: :divide, value: v}) do
      %{event_type: :value_divided, value: v}
  end

  # event handler to apply events to the state
  def handle_event(%{value: val}, %{event_type: :value_added, value: v}) do
    %{value: val + v}
  end

  def handle_event(%{value: val}, %{event_type: :value_subtracted, value: v}) do
    %{value: val - v}
  end

  def handle_event(%{value: val}, %{event_type: :value_multiplied, value: v}) do
    %{value: val * v}
  end

  def handle_event(%{value: val}, %{event_type: :value_divided, value: v}) do
    %{value: val / v}
  end
end
