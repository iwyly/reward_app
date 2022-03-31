defmodule RewardAppWeb.PageController do
  use RewardAppWeb, :controller

  # starting page when not logged in
  def welcome(conn, _params) do
    if !conn.assigns.current_user do
      render(conn, "welcome.html")
    else
      cond do
      conn.assigns.current_user.role == :user
      -> redirect(conn,to: Routes.member_path(conn, :member))

      conn.assigns.current_user.role == :admin
      -> redirect(conn,to: Routes.admin_path(conn, :admin))
      end
    end
  end

end
