defmodule RinhaBackendWeb.Router do

  use RinhaBackendWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", RinhaBackendWeb do
    pipe_through :api
    post "/payments", PaymentController, :create_payment
    get "/payments-summary", PaymentController, :get_summary
  end

  if Application.compile_env(:rinha_backend, :dev_routes) do
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: RinhaBackendWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
