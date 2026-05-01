defmodule EventSourcedCalculator.V3 do
  @moduledoc """
  Event sourcing calculator with mixed error handling strategies.

  This module demonstrates three different error handling approaches:
  1. **Silent Clamping**: For addition and subtraction, values are silently clamped to bounds
  2. **Explicit Error Tuples**: For division by zero and multiplication overflow
  3. **Catch-all Fallthrough**: Unknown events are silently ignored

  State is constrained to the range [0, 10_000].
  """

  @max_state_value 10_000
  @min_state_value 0

  @doc """
  Handle add command with upper bound clamping.

  **Error Handling Strategy: Silent Clamping**

  If adding the value would exceed the maximum (10,000), the operation is silently
  clamped to the maximum. This means excess value is silently discarded without
  returning an error. The caller doesn't know if truncation occurred.

  ## Examples

      iex> state = %{value: 9_995}
      iex> handle_command(state, %{command: :add, value: 100})
      %{event_type: :value_added, value: 5}
      # Only 5 was added because 9_995 + 100 would be 10_095, clamped to 10_000 (upper bound clamping)

      iex> state = %{value: 100}
      iex> handle_command(state, %{command: :add, value: 50})
      %{event_type: :value_added, value: 50}
      # Normal operation, no clamping needed
  """
  def handle_command(%{value: val}, %{command: :add, value: v}) do
    %{event_type: :value_added, value: min(@max_state_value - val, v)}
  end

  @doc """
  Handle subtract command with lower bound clamping.

  **Error Handling Strategy: Silent Clamping**

  If subtracting the value would go below the minimum (0), the operation is silently
  clamped to zero. The actual subtraction amount is reduced without notifying the caller
  that the operation was partially prevented.

  ## Examples

      iex> state = %{value: 5}
      iex> handle_command(state, %{command: :sub, value: 20})
      %{event_type: :value_subtracted, value: 5}
      # Only 5 is subtracted because going below 0 is not allowed

      iex> state = %{value: 100}
      iex> handle_command(state, %{command: :sub, value: 30})
      %{event_type: :value_subtracted, value: 30}
      # Normal operation, no clamping needed
  """
  def handle_command(%{value: val}, %{command: :sub, value: v}) do
    %{event_type: :value_subtracted, value: max(@min_state_value, val - v)}
  end

  @doc """
  Handle multiply command with explicit overflow error handling.

  **Error Handling Strategy: Explicit Error Tuple**

  When multiplication would exceed the maximum value (10,000), this function explicitly
  returns an error tuple `{:error, :mul_failed}` instead of silently clamping. This is
  more explicit than add/subtract and allows the caller to decide how to handle the error.

  ## Examples

      iex> state = %{value: 500}
      iex> handle_command(state, %{command: :multiply, value: 30})
      {:error, :mul_failed}
      # 500 * 30 = 15,000 which exceeds max of 10,000, so error is returned

      iex> state = %{value: 100}
      iex> handle_command(state, %{command: :multiply, value: 50})
      %{event_type: :value_multiplied, value: 50}
      # 100 * 50 = 5,000 is within bounds, operation succeeds
  """
  def handle_command(%{value: val}, %{command: :multiply, value: v})
      when val * v > @max_state_value do
    {:error, :mul_failed}
  end

  def handle_command(%{value: _val}, %{command: :multiply, value: v}) do
    %{event_type: :value_multiplied, value: v}
  end

  @doc """
  Handle divide command with explicit division by zero error handling.

  **Error Handling Strategy: Explicit Error Tuple**

  Division by zero is caught by a guard clause that matches when divisor is 0, and
  returns an error tuple `{:error, :divide_failed}`. This prevents arithmetic errors
  and gives the caller control over error recovery.

  We do not return an error event but instead reject the command outright, this is a law in event "All events are immutable and Past Tense". If we were to return an event with an error, it would imply that the division by zero actually occurred, which is not the case. By returning an error tuple, we can prevent the creation of an invalid event and maintain the integrity of our event log.

  ## Examples

      iex> state = %{value: 100}
      iex> handle_command(state, %{command: :divide, value: 0})
      {:error, :divide_failed}
      # Division by zero is explicitly caught and returns error

      iex> state = %{value: 100}
      iex> handle_command(state, %{command: :divide, value: 4})
      %{event_type: :value_divided, value: 4}
      # Valid division, operation succeeds
  """
  def handle_command(%{value: _val}, %{command: :divide, value: 0}) do
    {:error, :divide_failed}
  end

  def handle_command(%{value: _val}, %{command: :divide, value: v}) do
    %{event_type: :value_divided, value: v}
  end

  @doc """
  Apply events to state to update the calculator value.

  **Error Handling Strategy: Catch-all Fallthrough**

  The `handle_event/2` functions include a catch-all clause that silently ignores
  unknown event types by returning the state unchanged. This prevents crashes from
  unexpected events but means unknown events are silently dropped without logging.

  ## Examples

      iex> state = %{value: 50}
      iex> handle_event(state, %{event_type: :value_added, value: 25})
      %{value: 75}
      # Normal event processing

      iex> state = %{value: 100}
      iex> handle_event(state, %{event_type: :unknown_event, value: 999})
      %{value: 100}
      # Unknown event is silently ignored, state unchanged
  """
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

  # Catch-all clause: silently ignores unknown events
  # This is the second law of event sourcing "Applying a Failure Event Must Always Return the Previous State". This clause would catch an event produced by command %{command: :divide, value: 0} which would produce an event with event_type :divide_failed. This event should not change the state of the calculator, as the division by zero did not actually occur. By returning the previous state unchanged, we maintain the integrity of our state and ensure that failure events do not have unintended side effects.
  def handle_event(%{value: _val} = state, _) do
    state
  end

  #   iex(17)> cmds = [%{command: :add, value: 100}, %{command: :sub, value: 50}, %{command: :multiply, value: 6}, %{command: :divide, value: 5}]
  # [
  #   %{command: :add, value: 100},
  #   %{command: :sub, value: 50},
  #   %{command: :multiply, value: 6},
  #   %{command: :divide, value: 5}
  # ]
  # iex(18)> init = %{value: 0}
  # %{value: 0}
  # iex(19)> cmds |> List.foldl(init, fn cmd, acc -> handle_event(acc, handle_command(acc, cmd)) end)
  # %{value: 60.0}
  # iex(20)>
end
