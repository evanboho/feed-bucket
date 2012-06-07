class AddEmailToRides < ActiveRecord::Migration
  def change
    add_column :rides, :email, :string
  end
end
