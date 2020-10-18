class CreateRoomUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :room_users do |t|
      t.references :user, foreign_kye: true
      t.references :room, foreign_kye: true
      t.timestamps
    end
  end
end
