defmodule MyApp do
  alias MyApp.User

  def create_user_subscription(%User{credit_card: credit_card} = user) do
    case MyApp.StipeLib.make_payment(credit_card) do
      {:ok, _} ->
        {:ok, %{user | last_payment_status: :success}}

      {:error, _error} ->
        {:ok, %{user | last_payment_status: :failed}}
    end
  end
end
