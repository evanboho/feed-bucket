class AddClCityToRides < ActiveRecord::Migration
  def change
    add_column :rides, :cl_city, :string
  end
end
