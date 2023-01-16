defmodule MyApp.MockStipeServer do
  use Plug.Router

  plug(:match)

  plug(Plug.Parsers,
    parsers: [:json],
    pass: ["application/json"],
    json_decoder: Jason
  )

  plug(:dispatch)

  post "/make_payment" do
    case conn.body_params do
      %{"credit_card" => "0000"} ->
        conn
        |> send_resp(200, "")

      %{"credit_card" => "9999"} ->
        conn
        |> send_resp(422, "credit card is valid, but needs human validation")

      _ ->
        conn
        |> send_resp(422, "invalid credit card")
    end
  end
end
