class CreateRooms < ActiveRecord::Migration[8.1]
  def change
    create_table :rooms do |t|
      t.string :code, index: { unique: true }, limit: 6, null: false
      t.string :name, null: false
      t.timestamps
    end
  end
end
