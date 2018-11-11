defmodule Exred.Node.Debug do
  @moduledoc """
  Logs debug messages in Exred flows.
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
  @ui_attributes %{fire_button: false, left_icon: nil, right_icon: "bug_report"}

  use Exred.Library.NodePrototype
  require Logger
  alias Exred.Scheduler.EventChannel

  @impl true
  def handle_msg(msg, state) do
    event = "notification"
    debug_data = msg

    event_msg = %{
      node_id: state.node_id,
      node_name: state.config.name.value,
      debug_data: debug_data
    }

    state.send_event.(event, event_msg)
    {msg, state}
  end
end
