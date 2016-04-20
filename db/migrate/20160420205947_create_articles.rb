class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.text :body
      t.integer :organization_id
      t.string :title
      t.integer :user_id
      t.timestamps
    end
  end
end
