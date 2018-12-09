class CreateArticles < ActiveRecord::Migration[5.2]
  def change
    create_table :articles do |t|
      t.string :title
      t.string :publisher
      t.date :last_updated
      t.belongs_to :topic


    end
  end
end

# t.timestamps
