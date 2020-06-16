class CreateLists < ActiveRecord::Migration[6.0]
  def change
    create_table :lists do |t|
      t.string :name
      t.string :description
      t.boolean :public
      t.belongs_to :user, index: true
      t.references :movie, index: true

      t.timestamps
    end
  end
end
