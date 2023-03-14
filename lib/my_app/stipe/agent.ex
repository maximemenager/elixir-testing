defmodule MyApp.Stipe.Agent do
  @behaviour MyApp.StipeBehaviour

  use Agent

  def start_link(opts) do
    Agent.start_link(fn -> opts end, name: __MODULE__)
  end

  @impl true
  def make_payment(value) do
    Agent.update(__MODULE__, fn state -> state ++ [value] end)

    case value do
      "0000" ->
        {:ok, nil}

      "9999" ->
        {:error, "credit card is valid, but needs human validation"}

      _ ->
        {:error, "invalid credit card"}
    end
  end

  def received_card(card) do
    with state <- Agent.get(__MODULE__, & &1),
         index when is_number(index) <- Enum.find_index(state, &(&1 == card)) do
      Agent.update(__MODULE__, fn state ->
        {_, state} = List.pop_at(state, index)

        state
      end)

      true
    else
      _ ->
        false
    end
  end
end
