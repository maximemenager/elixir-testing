defmodule MyApp.StipeBehaviour do
  @callback make_payment(credit_card :: String.t()) :: {:ok, nil} | {:error, String.t()}

  def make_payment(credit_card) do
    impl().make_payment(credit_card)
  end

  defp impl() do
    Application.get_env(:my_app, :stipe_client)
  end
end
