class AddGmapsToRidemaps < ActiveRecord::Migration
  def change
    add_column :ridemaps, :gmaps, :boolean
  end
end
