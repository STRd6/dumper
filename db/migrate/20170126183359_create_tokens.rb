class CreateTokens < ActiveRecord::Migration[5.0]
  def change
    create_table :tokens, id: :uuid do |t|
      t.references :account, foreign_key: true, null: false
      t.boolean :expired, null: false, default: false

      t.timestamps null: false
    end

  end
end
