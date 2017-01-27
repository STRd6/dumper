class CreateAccounts < ActiveRecord::Migration[5.0]
  def change
    create_table :accounts do |t|
      t.boolean :verified, null: false, default: false
      t.string :email, null: false
      t.string :domain, null: false
      t.uuid :perishable_token,
        null: false,
        default: -> { "uuid_generate_v4()" }

      t.timestamps null: false
    end
  end
end
