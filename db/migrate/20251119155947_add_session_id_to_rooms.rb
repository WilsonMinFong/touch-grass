class AddSessionIdToRooms < ActiveRecord::Migration[8.1]
  def change
    add_column :rooms, :session_id, :string
    add_index :rooms, :session_id
  end
end
