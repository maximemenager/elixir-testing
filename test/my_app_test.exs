defmodule MyAppTest do
  use ExUnit.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  setup_all do
    HTTPoison.start()
    :ok
  end

  describe "make a payment" do
    test "with a valid credit card" do
      use_cassette "payment_success" do
        response =
          HTTPoison.post!(
            "http://localhost:4000/make_payment",
            Jason.encode!(%{credit_card: "0000"}),
            [{"Content-Type", "application/json"}]
          )

        assert response.status_code == 200
        assert response.body == ""
      end
    end

    test "with a valid credit card, but with validation" do
      use_cassette "payment_failure_valid_card" do
        response =
          HTTPoison.post!(
            "http://localhost:4000/make_payment",
            Jason.encode!(%{credit_card: "9999"}),
            [{"Content-Type", "application/json"}]
          )

        assert response.status_code == 422
        assert response.body == "credit card is valid, but needs human validation"
      end
    end

    test "with an invalid credit card" do
      use_cassette "payment_failure_invalid_card" do
        response =
          HTTPoison.post!(
            "http://localhost:4000/make_payment",
            Jason.encode!(%{credit_card: "1234"}),
            [{"Content-Type", "application/json"}]
          )

        assert response.status_code == 422
        assert response.body == "invalid credit card"
      end
    end
  end
end
