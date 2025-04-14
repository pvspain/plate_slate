defmodule PlateSlateWeb.Schema.Mutation.CreateCategoryTest do
  use PlateSlateWeb.ConnCase, async: true

  setup do
    PlateSlate.Seeds.run()
  end

  @query """
  mutation ($category: CategoryInput!) {
    createCategory(input: $category) {
      name
      description
    }
  }
  """

  test "createCategory field creates a category" do
    category = %{
      "name" => "Desserts",
      "description" => "Sweet things"
    }

    IO.puts("category: #{inspect(category)}\n")

    conn = build_conn()

    conn =
      post conn, "/api",
        query: @query,
        variables: %{"category" => category}

    assert json_response(conn, 200) == %{
             "data" => %{
               "createCategory" => %{
                 "name" => category["name"],
                 "description" => category["description"]
               }
             }
           }
  end
end
