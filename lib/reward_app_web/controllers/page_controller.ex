defmodule RewardAppWeb.PageController do
  use RewardAppWeb, :controller
  alias RewardApp.Accounts


  def member(conn, _params) do
    members_emails = Accounts.get_all_members() |> Enum.map(fn member -> member.email end)

    render(conn, "member.html", members_emails: members_emails)
  end
  def admin(conn, _params) do
    render(conn, "admin.html")
  end

  def welcome(conn, _params) do
    render(conn, "welcome.html")
  end

  def grant_points_to_member(conn, %{"grant_details" => _grant_details}) do


    redirect(conn,to: Routes.page_path(conn, :member) )
  end
end
