class CreateVideos < ActiveRecord::Migration[6.0]
  def change
    create_table :videos do |t|
      t.integer :size
      t.string :type
      t.string :url

      t.timestamps
    end
  end
end
