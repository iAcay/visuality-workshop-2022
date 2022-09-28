class CreateArticles < ActiveRecord::Migration[7.0]
  def change
    create_table :articles do |t|
      t.string :title, null: false, index: { unique: true }
      t.text :content

      t.timestamps
    end
  end
end
