defmodule RinhaBackend.Payments.Payments do
  import Ecto.Query, warn: false
  alias RinhaBackend.Repo
  alias RinhaBackend.Payments.Payment
  alias RinhaBackend.Payments.HealthService

  @default_url "http://payment-processor-default:8080/payments"
  @fallback_url "http://payment-processor-fallback:8080/payments"

  def process_payment(attrs) do
    processor = select_processor()
    case call_processor(processor, attrs) do
      {:ok, response} ->
        save_payment(attrs, processor)
        {:ok, response}
      {:error, reason} ->
        {:error, reason}
    end
  end

  defp select_processor do
  alias RinhaBackend.Payments.HealthService
    default_health = HealthService.get_health(:default)
  alias RinhaBackend.Payments.HealthService
    fallback_health = HealthService.get_health(:fallback)
    cond do
      not default_health.failing -> :default
      not fallback_health.failing -> :fallback
      true -> :none
    end
  end

  defp call_processor(:default, attrs) do
    request_payment(@default_url, attrs)
  end

  defp call_processor(:fallback, attrs) do
    request_payment(@fallback_url, attrs)
  end

  defp call_processor(:none, _attrs) do
    {:error, "All processors are down"}
  end

  defp request_payment(url, %{correlation_id: cid, amount: amount}) do
    payload = %{
      correlationId: cid,
      amount: amount,
      requestedAt: DateTime.utc_now() |> DateTime.to_iso8601()
    }
    headers = [{"Content-Type", "application/json"}]
    case HTTPoison.post(
      url,
      Jason.encode!(payload),
      headers,
      timeout: 500,
      recv_timeout: 500
    ) do
      {:ok, %HTTPoison.Response{status_code: 200}} -> {:ok, "processed"}
      error -> {:error, inspect(error)}
    end
  end

  defp save_payment(attrs, processor) do
    %Payment{}
    |> Payment.changeset(Map.put(attrs, :processor, Atom.to_string(processor)))
    |> Repo.insert()
  end

  def summary(from, to) do
    query = from p in Payment,
      where: p.inserted_at >= ^from and p.inserted_at <= ^to,
      group_by: p.processor,
      select: {p.processor, count(p.id), sum(p.amount)}
    results = Repo.all(query)

    %{
      "default" => format_result(results, "default"),
      "fallback" => format_result(results, "fallback")
    }
  end

  defp format_result(results, processor) do
    case List.keyfind(results, processor, 0) do
      {^processor, count, amount} -> %{totalRequests: count, totalAmount: amount}
      nil -> %{totalRequests: 0, totalAmount: 0.0}
    end
  end
end
