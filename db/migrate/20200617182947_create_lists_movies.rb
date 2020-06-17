class CreateListsMovies < ActiveRecord::Migration[6.0]
  def change
    create_table :lists do |t|
      t.string :name
      t.string :description
      t.boolean :public
      t.belongs_to :user, index: true

      t.timestamps
    end
    
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
    
    create_table :lists_movies, id: false do |t|
      t.belongs_to :list
      t.belongs_to :movie
    end
  end
end
