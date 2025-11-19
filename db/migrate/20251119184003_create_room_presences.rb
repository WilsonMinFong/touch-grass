class CreateRoomPresences < ActiveRecord::Migration[8.1]
  def change
    create_table :room_presences do |t|
      t.references :room, null: false, foreign_key: true
      t.string :session_id
      t.datetime :last_seen

      t.timestamps
    end

    add_index :room_presences, [ :room_id, :session_id ], unique: true
    add_index :room_presences, :last_seen
  end
end
