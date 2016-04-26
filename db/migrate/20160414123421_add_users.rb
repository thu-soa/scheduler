class AddUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string  :name
      t.timestamps null: false
    end
    create_table :oauth_tokens do |t|
      t.string    :token_string
      t.timestamps null: false
      t.datetime  :valid_until
      t.integer   :user_id
    end
  end
end
