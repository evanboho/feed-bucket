class CreateRidemaps < ActiveRecord::Migration
  def change
    create_table :ridemaps do |t|
      t.string :start_city
      t.string :start_state
      t.float :latitude
      t.float :longitude
      t.string :end_city
      t.string :end_state
      t.float :end_lat
      t.float :end_long

      t.timestamps
    end
  end
end
