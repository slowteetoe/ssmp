class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :id
      t.string :uuid
      t.string :sender
      t.text :contents
      t.timestamp :expires_at
      t.integer :decryption_attempts, {:default => 0}

      t.timestamps
    end
  end
end
