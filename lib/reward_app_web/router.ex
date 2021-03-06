defmodule RewardAppWeb.Router do
  use RewardAppWeb, :router

  import RewardAppWeb.UserAuth
  alias RewardAppWeb.EnsureRolePlug

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {RewardAppWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :user do
    plug EnsureRolePlug, [:admin, :user]
  end

  pipeline :admin do
    plug EnsureRolePlug, :admin
  end

  scope "/", RewardAppWeb do
    pipe_through :browser

    get "/", PageController, :welcome
  end

  scope "/", RewardAppWeb do
    pipe_through [:browser, :user]

    get "/member", MemberController, :member
    post "/member/grant_points_to_member", MemberController, :grant_points_to_member
  end

  scope "/", RewardAppWeb do
    pipe_through [:browser, :admin]

    get "/admin", AdminController, :admin
    get "/admin/show_reward_pools", AdminController, :admin_show_reward_pools
    post "/admin/edit_reward_pool", AdminController, :admin_edit_reward_pool
    get "/admin/show_per_month_reports", AdminController, :admin_show_per_month_reports
    post "/admin/show_per_month_reports", AdminController, :admin_show_per_month_reports
    get "/admin/manage_reward_entries", AdminController, :manage_reward_entries
    get "/admin/delete_reward_entry", AdminController, :delete_reward_entry
  end

  scope "/dev" do
    pipe_through [:browser]
    forward "/mailbox", Plug.Swoosh.MailboxPreview, base_path: "/dev/mailbox"
  end

  # Other scopes may use custom stacks.
  # scope "/api", RewardAppWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: RewardAppWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      #forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", RewardAppWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    get "/users/register", UserRegistrationController, :new
    post "/users/register", UserRegistrationController, :create
    get "/users/log_in", UserSessionController, :new
    post "/users/log_in", UserSessionController, :create
    get "/users/reset_password", UserResetPasswordController, :new
    post "/users/reset_password", UserResetPasswordController, :create
    get "/users/reset_password/:token", UserResetPasswordController, :edit
    put "/users/reset_password/:token", UserResetPasswordController, :update
  end

  scope "/", RewardAppWeb do
    pipe_through [:browser, :require_authenticated_user]

    get "/users/settings", UserSettingsController, :edit
    put "/users/settings", UserSettingsController, :update
    get "/users/settings/confirm_email/:token", UserSettingsController, :confirm_email
  end

  scope "/", RewardAppWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete
    get "/users/confirm", UserConfirmationController, :new
    post "/users/confirm", UserConfirmationController, :create
    get "/users/confirm/:token", UserConfirmationController, :edit
    post "/users/confirm/:token", UserConfirmationController, :update
  end
end
