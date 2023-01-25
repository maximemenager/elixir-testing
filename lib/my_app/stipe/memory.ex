defmodule MyApp.Stipe.Memory do
  @behaviour MyApp.StipeBehaviour

  @impl true
  def make_payment("0000"), do: {:ok, nil}

  @impl true
  def make_payment("9999"), do: {:error, "credit card is valid, but needs human validation"}

  @impl true
  def make_payment(_), do: {:error, "invalid credit card"}
end
