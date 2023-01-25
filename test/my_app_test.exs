defmodule MyAppTest do
  use ExUnit.Case, async: true

  import Hammox

  alias MyApp.User

  setup :verify_on_exit!

  describe "create_user_subscription/1" do
    test "with good credit card" do
      expect(MyApp.StipeMock, :make_payment, fn credit_card ->
        assert credit_card == "0000"
        {:ok, nil}
      end)

      user = %User{email: "foo@bar.com", credit_card: "0000"}

      assert {:ok, %User{last_payment_status: :success}} = MyApp.create_user_subscription(user)
    end

    test "with bad credit card" do
      expect(MyApp.StipeMock, :make_payment, fn credit_card ->
        assert credit_card == "1234"
        {:error, "invalid credit card"}
      end)

      user = %User{email: "foo@bar.com", credit_card: "1234"}

      assert {:ok, %User{last_payment_status: :failed}} = MyApp.create_user_subscription(user)
    end

    test "with no credit card" do
      expect(MyApp.StipeMock, :make_payment, fn credit_card ->
        refute credit_card
        {:error, "invalid credit card"}
      end)

      user = %User{email: "foo@bar.com", credit_card: nil}

      assert {:ok, %User{last_payment_status: :failed}} = MyApp.create_user_subscription(user)
    end

    test "with pending credit card validation" do
      expect(MyApp.StipeMock, :make_payment, fn credit_card ->
        assert credit_card == "9999"
        {:error, "credit card is valid, but needs human validation"}
      end)

      user = %User{email: "foo@bar.com", credit_card: "9999"}

      assert {:ok, %User{last_payment_status: :failed}} = MyApp.create_user_subscription(user)
    end
  end
end
