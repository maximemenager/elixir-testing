defmodule MyApp.StipeLib do
  def make_payment(credit_card) do
    request =
      :hackney.post(
        url() <> "/make_payment",
        [{"content-type", "application/json"}],
        Jason.encode!(%{credit_card: credit_card}),
        with_body: true
      )

    case request do
      {:ok, 200, _headers, _response} ->
        {:ok, nil}

      {:ok, _, _headers, response} ->
        {:error, response}
    end
  end

  defp url() do
    "http://localhost:#{System.get_env("PORT", "4000") |> String.to_integer()}"
  end
end
