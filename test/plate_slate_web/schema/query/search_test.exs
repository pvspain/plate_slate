defmodule PlateSlateWeb.Schema.Query.SearchTest do
  use PlateSlateWeb.ConnCase, async: true

  setup do
    PlateSlate.Seeds.run()
  end

  @query """
  query Search($term: String!) {
    search(matching: $term) {
      name
      __typename
    }
  }
  """
  @variables %{term: "e"}
  test "Search returns a list of menu items and categories" do
    response = get(build_conn(), "/api", query: @query, variables: @variables)
    assert %{"data" => %{"search" => results}} = json_response(response, 200)
    assert length(results) > 0
    assert Enum.find(results, &(&1["__typename"] == "Category"))
    assert Enum.find(results, &(&1["__typename"] == "MenuItem"))
  end

  @query """
  query Search($term: String!) {
    search(matching: $term) {
      ... MenuItemFields
      ... CategoryFields
      __typename
    }
  }

  fragment MenuItemFields on MenuItem {
    name
  }

  fragment CategoryFields on Category {
    name
    items {
      ... MenuItemFields
    }
  }
  """
  @variables %{term: "e"}
  test "Search, with query using fragments, returns a list of menu items and categories" do
    response = get(build_conn(), "/api", query: @query, variables: @variables)
    assert %{"data" => %{"search" => results}} = json_response(response, 200)
    assert length(results) > 0
    assert Enum.find(results, &(&1["__typename"] == "Category"))
    assert Enum.find(results, &(&1["__typename"] == "MenuItem"))
  end

  @query """
  query Search($term: String!) {
    search(matching: $term) {
      ... MenuItemFields
      ... CategoryFields
      ... CyclicFields
      __typename
    }
  }

  fragment MenuItemFields on MenuItem {
    name
  }

  fragment CategoryFields on Category {
    name
    items {
      ... MenuItemFields
    }
    ... CyclicFields
  }

  fragment CyclicFields on Category {
    __typename
    ...CategoryFields
  }
  """
  @variables %{term: "e"}
  test "Search, with query using cyclic fragments, returns a list of menu items and categories" do
    response = get(build_conn(), "/api", query: @query, variables: @variables)

    assert %{
             "errors" => [
               %{
                 "locations" => [%{"column" => 1, "line" => 14}],
                 "message" =>
                   "Cannot spread fragment \"CategoryFields\" within itself via \"CyclicFields\", \"CategoryFields\"."
               },
               %{
                 "locations" => [%{"column" => 1, "line" => 22}],
                 "message" =>
                   "Cannot spread fragment \"CyclicFields\" within itself via \"CategoryFields\", \"CyclicFields\"."
               }
             ]
           } = json_response(response, 200)
  end
end
