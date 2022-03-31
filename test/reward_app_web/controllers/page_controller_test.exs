defmodule RewardAppWeb.PageControllerTest do
  use RewardAppWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Before you can use this site you need to sign in as a member or admin! "
  end
end
