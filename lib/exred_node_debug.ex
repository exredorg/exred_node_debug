defmodule Exred.Node.Debug do
  @moduledoc """
  Documentation for Exred.Node.Debug
  """
  
  @name "Debug"
  @category "output"
  @info """
  This node logs every message it receives  
  using the Logger module and also publishes  
  them to a Phoenix channel that the editor  
  back-end can sign up for.
  """
  @config %{
    name: %{value: @name, type: "string", attrs: %{max: 20}}
  }

  use Exred.Library.NodePrototype
  require Logger
  alias Exred.Scheduler.EventChannelClient

  @impl true
  def handle_msg(msg, state) do
    Logger.info("GOT: #{inspect msg}")
    event = "notification"
    debug_data = msg
    event_msg = %{node_id: state.node_id, node_name: state.config.name.value, debug_data: debug_data}
    EventChannelClient.broadcast event, event_msg
    {msg, state}
  end

end
