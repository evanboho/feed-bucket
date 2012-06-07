class CreateRides < ActiveRecord::Migration
  def change
    create_table :rides do |t|
      t.string :title
      t.text :body
      t.string :url
      t.datetime :published_at
      t.string :guid

      t.timestamps
    end
  end
end
