defmodule RinhaBackend.Payments.HealthService do
  use GenServer

  @default_url "http://payment-processor-default:8080/payments/service-health"
  @fallback_url "http://payment-processor-fallback:8080/payments/service-health"

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(state) do
    schedule_health_check()
    {:ok, state}
  end

  def handle_info(:health_check, state) do
    new_state =
      state
      |> update_health(:default, @default_url)
      |> update_health(:fallback, @fallback_url)
    schedule_health_check()
    {:noreply, new_state}
  end

  defp update_health(state, processor, url) do
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        health_data = Jason.decode!(body)
        Map.put(state, processor, %{
          failing: health_data["failing"],
          min_response_time: health_data["minResponseTime"]
        })
      _ ->
        state
    end
  end

  defp schedule_health_check do
    Process.send_after(self(), :health_check, 5000)
  end

  def get_health(processor) do
    GenServer.call(__MODULE__, {:get_health, processor})
  end

  def handle_call({:get_health, processor}, _from, state) do
    {:reply, Map.get(state, processor, %{failing: true, min_response_time: 1000}), state}
  end

end
