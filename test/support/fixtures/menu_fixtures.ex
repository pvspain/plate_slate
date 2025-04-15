defmodule PlateSlate.MenuFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `PlateSlate.Menu` context.
  """

  @doc """
  Generate a category.
  """
  def category_fixture(attrs \\ %{}) do
    {:ok, category} =
      attrs
      |> Enum.into(%{
        description: "some description",
        name: "some name"
      })
      |> PlateSlate.Menu.create_category()

    category
  end

  @doc """
  Generate a item_tag.
  """
  def item_tag_fixture(attrs \\ %{}) do
    {:ok, item_tag} =
      attrs
      |> Enum.into(%{
        description: "some description",
        name: "some name"
      })
      |> PlateSlate.Menu.create_item_tag()

    item_tag
  end

  @doc """
  Generate a item.
  """
  def item_fixture(attrs \\ %{}) do
    {:ok, item} =
      attrs
      |> Enum.into(%{
        added_on: ~D[2025-04-01],
        description: "some description",
        name: "some name",
        price: "120.5",
        category_id: category_fixture().id
      })
      |> PlateSlate.Menu.create_item()

    item
  end
end
