defmodule Exred.Node.DebugTest do
  use ExUnit.Case
  doctest Exred.Node.Debug

  use Exred.NodeTest, module: Exred.Node.Debug

  setup_all do
    start_node()
  end

  @doc """
    Sends a message to the runnig node and wait for a message back.
    A Debug node should simply forward the message. (and send a notification event)
  """
  test "forwards message", context do
    Exred.Node.Debug.add_out_node(context.pid, self())
    msg = %{payload: "hello world"}
    send(context.pid, msg)
    assert_receive %{payload: _}, 1000
  end
end
