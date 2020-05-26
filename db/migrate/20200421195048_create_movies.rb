class CreateMovies < ActiveRecord::Migration[6.0]
  def change
    create_table :movies do |t|
      t.string :title
      t.string :tagline
      t.string :overview
      t.date :release_date
      t.string :poster_url
      t.string :backdrop_url
      t.string :imdb_id

      t.timestamps
    end
  end
end
