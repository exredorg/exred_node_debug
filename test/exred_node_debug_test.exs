defmodule Exred.Node.DebugTest do
  use ExUnit.Case
  doctest Exred.Node.Debug

  test "greets the world" do
    msg = "hello"

    state =
      %{
        node_id: :test,
        send_event: &IO.inspect({&1, &2}, label: "SENDING EVENT")
      }
      |> Enum.into(Exred.Node.Debug.attributes())

    assert Exred.Node.Debug.handle_msg(msg, state) == {msg, state}
  end
end
