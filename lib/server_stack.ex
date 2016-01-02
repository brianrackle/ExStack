defmodule Seq.StackServer do
  use GenServer

  # public interface
  def start_link(current_stack) do
    GenServer.start_link(__MODULE__, current_stack, name: __MODULE__)
  end

  def push(value) do
    GenServer.cast(__MODULE__, {:push, value})
  end

  def pop do
    GenServer.cast(__MODULE__, :pop)
  end

  def get do
    GenServer.call(__MODULE__, :get)
  end

  # GenServer implementation
  def handle_cast({:push, value}, current_stack) do
    {:noreply, [value | current_stack]}
  end

  # message to handle, PID of the client, server state
  def handle_cast(:pop, [_ | tail] = _current_stack) do
    #reply to client, passing back, set new state
    {:noreply, tail}
  end

  def handle_cast(:pop, [] = current_stack) do
    #reply to client, passing back, set new state
    {:noreply, current_stack}
  end

  # message to handle, server state
  def handle_call(:get, _from, [head | _] = current_stack) do
    #reply to client, set new state
    {:reply, head, current_stack}
  end

  def handle_call(:get, _from, [] = current_stack) do
    {:reply, nil, current_stack}
  end

end
