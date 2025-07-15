defmodule RinhaBackendWeb.PaymentController do
  use RinhaBackendWeb, :controller
  alias RinhaBackend.Payments.Payments

  def create_payment(conn, %{"correlationId" => correlationId, "amount" => amount}) do
    case Payments.process_payment(%{correlation_id: correlationId, amount: amount}) do
      {:ok, _} -> send_resp(conn, 201, "")
      {:error, err} -> send_resp(conn, 500, err)
    end
  end

  def get_summary(conn, %{"from" => from, "to"=> to}) do
    with {:ok, from_dt} <- DateTime.from_iso8601(from),
    {:ok, to_dt} <- DateTime.from_iso8601(to) do
      summary = Payments.summary(from_dt, to_dt)
      json(conn, summary)
    else
      _ -> send_resp(conn, 400, "invalid date")
    end
  end

  def get_summary(conn) do
    summary = Payments.summary(DateTime.from_unix(0), DateTime.utc_now())
    json(conn, summary)
  end

end
