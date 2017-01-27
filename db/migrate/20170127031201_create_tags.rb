class CreateTags < ActiveRecord::Migration[5.0]
  def change
    create_table :tags do |t|
      t.references :account, foreign_key: true, null: false
      t.references :content, foreign_key: {to_table: :content}, null: false
      t.string :tag, null: false

      t.timestamps null: false
    end

    add_index :tags, [:tag, :account_id, :content_id], unique: true
  end
end
