defmodule PlateSlate.Menu.ItemTag do
  use Ecto.Schema
  import Ecto.Changeset

  schema "item_tags" do
    field :name, :string
    field :description, :string

    many_to_many(:items, PlateSlate.Menu.Item, join_through: "items_taggings")

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(item_tag, attrs) do
    item_tag
    |> cast(attrs, [:description, :name])
    |> validate_required([:name])
  end
end
