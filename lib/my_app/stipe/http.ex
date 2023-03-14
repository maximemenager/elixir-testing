defmodule MyApp.Stipe.HTTP do
  @behaviour MyApp.StipeBehaviour

  @impl true
  def make_payment(credit_card), do: MyApp.StipeLib.make_payment(credit_card)
end
