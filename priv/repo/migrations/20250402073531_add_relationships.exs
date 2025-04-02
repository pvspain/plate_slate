defmodule PlateSlate.Repo.Migrations.AddRelationships do
  use Ecto.Migration

  def change do
    alter table(:items) do
      modify :name, :string, null: false
      modify :price, :decimal, null: false
      modify :added_on, :date, null: false, default: fragment("NOW()")
      add :category_id, references(:categories, on_delete: :nothing)
    end

    alter table(:categories) do
      modify :name, :string, null: false
    end

    alter table(:item_tags) do
      modify :name, :string, null: false
    end

    create table(:items_taggings, primary_key: false) do
      add :item_id, references(:items), null: false
      add :item_tag_id, references(:item_tags), null: false
    end

  end
end
