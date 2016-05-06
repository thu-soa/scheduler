class AddMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string  :title
      t.string  :user_id
      t.string  :url
      t.string  :source
      t.text    :description
      t.string  :msg_type
      t.string  :source
      t.timestamps null: false
    end
  end
end
