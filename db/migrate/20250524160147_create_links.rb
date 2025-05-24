class CreateLinks < ActiveRecord::Migration[8.0]
  def change
    create_table :links do |t|
      t.string :url
      t.text :name
      t.references :website, null: false, foreign_key: true

      t.timestamps
    end
  end
end
