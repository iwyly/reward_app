defmodule RewardAppWeb.PageController do
  use RewardAppWeb, :controller
  alias RewardApp.Accounts
  alias RewardApp.RewardManager
  alias RewardApp.Accounts.UserNotifier

  # starting page when not logged in
  def welcome(conn, _params) do
    if !conn.assigns.current_user do
      render(conn, "welcome.html")
    else
      cond do
      conn.assigns.current_user.role == :user
      -> redirect(conn,to: Routes.page_path(conn, :member))

      conn.assigns.current_user.role == :admin
      -> redirect(conn,to: Routes.page_path(conn, :admin))
      end
    end
  end

  # member page
  def member(conn, _params) do
    current_user_email = conn.assigns.current_user.email

    members_emails = Accounts.get_all_members()
                     |> Enum.map(fn member -> member.email end)
                     |> List.delete(current_user_email)

    recent_granted_rewards = RewardManager.list_granted_rewards_by_user(current_user_email)
                             |> RewardManager.recent_rewards(3)

    render(conn, "member.html",
    members_emails: members_emails,
    recent_granted_rewards: recent_granted_rewards
    )
  end
  # member grant points functionality
  def grant_points_to_member(conn, %{"grant_details" => grant_details}) do
    current_user_email = conn.assigns.current_user.email
    full_grant_details = Map.put(grant_details, "from", current_user_email)

    Accounts.grant_transfer(full_grant_details)
    RewardManager.create_reward_record(full_grant_details)
    UserNotifier.deliver_notify_member(full_grant_details)

    redirect(conn,to: Routes.page_path(conn, :member))
  end
  # admin main page
  def admin(conn, _params) do
    render(conn, "admin.html")
  end
  # admin show users' reward pools page
  def admin_show_reward_pools(conn, _params) do
    members_details = Accounts.get_all_members()
                     |> Enum.map(fn member ->
                        %{email: member.email, reward_pool: member.reward_pool}
                      end)

    render(conn, "show_reward_pools.html", members_details: members_details)
  end

  # admin edit user reward pool functionality
  def admin_edit_reward_pool(conn, %{"edit_details" => %{"email" => email, "new_amount" => new_amount}}) do

    Accounts.get_user_by_email(email)
    |> Accounts.update_user_reward_pool(%{reward_pool: new_amount})

    redirect(conn,to: Routes.page_path(conn, :admin_show_reward_pools))
  end
end
