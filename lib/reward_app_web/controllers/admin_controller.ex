defmodule RewardAppWeb.AdminController do
  use RewardAppWeb, :controller
  alias RewardApp.Accounts
  alias RewardApp.RewardManager

  # admin main page
  def admin(conn, _params) do
    render(conn, "admin.html")
  end
  # admin show users' reward pools page
  def admin_show_reward_pools(conn, _params) do
    members_details = Accounts.get_all_members()
                     |> Enum.map(&return_member_reward_pool_map(&1))

    render(conn, "show_reward_pools.html", members_details: members_details)
  end

  defp return_member_reward_pool_map(member) do
    %{email: member.email, reward_pool: member.reward_pool}
  end
  # admin edit user reward pool functionality
  def admin_edit_reward_pool(conn, %{"edit_details" => %{"email" => email, "new_amount" => new_amount}}) do

    Accounts.get_user_by_email(email)
    |> Accounts.update_user_reward_pool(%{reward_pool: new_amount})

    redirect(conn,to: Routes.admin_path(conn, :admin_show_reward_pools))
  end

  # admin per-month reports(summarizing rewards given to each user) page
  def admin_show_per_month_reports(conn, %{"show_reports" => %{"select_month" => month}})  do
    months = RewardManager.get_existing_months()
    reports_for_month = RewardManager.get_monthly_report_for_users(month)
    render(conn, "show_per_month_reports.html", months: months, reports_for_month: reports_for_month)
  end

  def admin_show_per_month_reports(conn, _params) do
    months = RewardManager.get_existing_months()
    render(conn, "show_per_month_reports.html", months: months, reports_for_month: false)
  end

end
