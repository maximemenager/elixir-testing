defmodule MyAppTest do
  use ExUnit.Case

  alias MyApp.User

  describe "create_user_subscription/1" do
    test "with good credit card" do
      user = %User{email: "foo@bar.com", credit_card: "0000"}

      assert {:ok, %User{last_payment_status: :success}} = MyApp.create_user_subscription(user)

      assert MyApp.Stipe.Agent.received_card("0000")
    end

    test "with bad credit card" do
      user = %User{email: "foo@bar.com", credit_card: "1234"}

      assert {:ok, %User{last_payment_status: :failed}} = MyApp.create_user_subscription(user)

      assert MyApp.Stipe.Agent.received_card("1234")
    end

    test "with no credit card" do
      user = %User{email: "foo@bar.com", credit_card: nil}

      assert {:ok, %User{last_payment_status: :failed}} = MyApp.create_user_subscription(user)
      assert MyApp.Stipe.Agent.received_card(nil)
    end

    test "with pending credit card validation" do
      user = %User{email: "foo@bar.com", credit_card: "9999"}

      assert {:ok, %User{last_payment_status: :failed}} = MyApp.create_user_subscription(user)
      assert MyApp.Stipe.Agent.received_card("9999")
    end
  end
end
