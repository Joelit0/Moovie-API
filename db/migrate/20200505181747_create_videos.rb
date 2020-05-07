class CreateVideos < ActiveRecord::Migration[6.0]
  def change
    create_table :videos do |t|
      t.integer :size
      t.string :format
      t.string :url
      t.belongs_to :movie, index: true

      t.timestamps null: false
    end
  end
end
