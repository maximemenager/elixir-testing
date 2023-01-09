defmodule MyAppTest do
  use ExUnit.Case

  import Mock

  alias MyApp.StipeLib
  alias MyApp.User

  describe "create_user_subscription/1" do
    test "with good credit card" do
      with_mock StipeLib, make_payment: fn _credit_card -> {:ok, nil} end do
        user = %User{email: "foo@bar.com", credit_card: "0000"}

        assert {:ok, %MyApp.User{last_payment_status: :success}} =
                 MyApp.create_user_subscription(user)
      end
    end

    test "with bad credit card" do
      with_mock StipeLib, make_payment: fn _credit_card -> {:error, "invalid credit card"} end do
        user = %User{email: "foo@bar.com", credit_card: "0000"}

        assert {:ok, %MyApp.User{last_payment_status: :failed}} =
                 MyApp.create_user_subscription(user)
      end
    end

    test "with no credit card" do
      with_mock StipeLib, make_payment: fn _credit_card -> {:error, "invalid credit card"} end do
        user = %User{email: "foo@bar.com", credit_card: nil}

        assert {:ok, %MyApp.User{last_payment_status: :failed}} =
                 MyApp.create_user_subscription(user)
      end
    end

    test "with pending credit card validation" do
      with_mock StipeLib,
        make_payment: fn _credit_card ->
          {:error, "credit card is valid, but needs human validation"}
        end do
        user = %User{email: "foo@bar.com", credit_card: nil}

        assert {:ok, %MyApp.User{last_payment_status: :failed}} =
                 MyApp.create_user_subscription(user)
      end
    end
  end
end
