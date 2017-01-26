class CreateContents < ActiveRecord::Migration[5.0]
  def change
    create_table :contents do |t|
      t.string :sha256, limit: 64, null: false
      t.string :mime_type, null: false
      t.integer :size, null: false
      t.json :meta

      t.timestamps null: false
    end
  end
end
