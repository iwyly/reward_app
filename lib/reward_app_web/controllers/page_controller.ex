defmodule RewardAppWeb.PageController do
  use RewardAppWeb, :controller

  def member(conn, _params) do
    render(conn, "member.html")
  end
  def admin(conn, _params) do
    render(conn, "admin.html")
  end

  def welcome(conn, _params) do
    render(conn, "welcome.html")
  end
end
