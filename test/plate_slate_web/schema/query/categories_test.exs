defmodule PlateSlateWeb.Schema.Query.CategoriesTest do
  use PlateSlateWeb.ConnCase, async: true

  setup do
    PlateSlate.Seeds.run()
  end

  @query """
  {
    categories {
      name
    }
  }
  """

  test "categories field returns categories" do
    conn = build_conn()
    conn = get conn, "/api", query: @query

    assert json_response(conn, 200) == %{
             "data" => %{
               "categories" => [
                 %{"name" => "Beverages"},
                 %{"name" => "Sandwiches"},
                 %{"name" => "Sides"}
               ]
             }
           }
  end

  @query """
  {
    categories(matching: "d") {
      name
    }
  }
  """

  test "categories field returns categories matching part-name" do
    conn = build_conn()
    conn = get conn, "/api", query: @query

    assert json_response(conn, 200) == %{
             "data" => %{
               "categories" => [
                 %{"name" => "Sandwiches"},
                 %{"name" => "Sides"}
               ]
             }
           }
  end

  @query """
  {
    categories(matching: 123) {
      name
    }
  }
  """

  test "categories field returns error for non-string matching argument" do
    conn = build_conn()
    conn = get conn, "/api", query: @query

    assert json_response(conn, 200) == %{
             "errors" => [
               %{
                 "locations" => [%{"column" => 14, "line" => 2}],
                 "message" => "Argument \"matching\" has invalid value 123."
               }
             ]
           }
  end

  @query """
  query ($term: String) {
    categories(matching: $term) {
      name
    }
  }
  """
  @variables %{term: "d"}

  test "categories field returns categories matching part-name using variable" do
    conn = build_conn()
    conn = get conn, "/api", query: @query, variables: @variables

    assert json_response(conn, 200) == %{
             "data" => %{
               "categories" => [
                 %{"name" => "Sandwiches"},
                 %{"name" => "Sides"}
               ]
             }
           }
  end

  @query """
  {
    categories(order: DESC) {
      name
    }
  }
  """

  test "categories field returns categories descending using literal" do
    conn = build_conn()
    conn = get conn, "/api", query: @query

    assert json_response(conn, 200) == %{
             "data" => %{
               "categories" => [
                 %{"name" => "Sides"},
                 %{"name" => "Sandwiches"},
                 %{"name" => "Beverages"}
               ]
             }
           }
  end

  @query """
  query ($order: SortOrder!){
    categories(order: $order) {
      name
    }
  }
  """
  @variables %{"order" => "DESC"}

  test "categories field returns categories descending using variable" do
    conn = build_conn()
    conn = get conn, "/api", query: @query, variables: @variables

    assert json_response(conn, 200) == %{
             "data" => %{
               "categories" => [
                 %{"name" => "Sides"},
                 %{"name" => "Sandwiches"},
                 %{"name" => "Beverages"}
               ]
             }
           }
  end
end
