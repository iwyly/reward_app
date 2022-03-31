defmodule RewardAppWeb.MemberController do
  use RewardAppWeb, :controller
  alias RewardApp.Accounts
  alias RewardApp.RewardManager
  alias RewardApp.Accounts.UserNotifier

  # memebr page
  def member(conn, _params) do
    current_user_email = conn.assigns.current_user.email

    members_emails = Accounts.get_all_members()
                     |> Enum.map(&return_member_email(&1))
                     |> List.delete(current_user_email)

    recent_granted_rewards = RewardManager.list_granted_rewards_by_user(current_user_email)
                             |> RewardManager.recent_rewards(3)

    render(conn, "member.html",
    members_emails: members_emails,
    recent_granted_rewards: recent_granted_rewards
    )
  end

  defp return_member_email(member), do: member.email

  # member grant points functionality
  def grant_points_to_member(conn, %{"grant_details" => grant_details}) do
    current_user_email = conn.assigns.current_user.email
    full_grant_details = Map.put(grant_details, "from", current_user_email)

    Accounts.grant_transfer(full_grant_details)
    RewardManager.create_reward_record(full_grant_details)
    UserNotifier.deliver_notify_member(full_grant_details)

    redirect(conn,to: Routes.member_path(conn, :member))
  end
end
