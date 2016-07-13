class CreateElevators < ActiveRecord::Migration
  def change
    create_table :elevators do |t|
      t.integer :number
      t.timestamps null: false
    end
  end
end
