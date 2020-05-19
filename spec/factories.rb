FactoryBot.define do
  factory :movie do
    title { "The Lord of the Rings: The Fellowship of the Ring" }
    tagline { "One ring to rule them all" }
    overview { "The future of civilization rests in the fate of the One Ring" }
    release_date { "2001-01-12" }
    poster_url { "https://m.media-amazon.com/images/M/MV5BN2EyZjM3NzUtNWUzMi00MTgxLWI0NTctMzY4M2VlOTdjZWRiXkEyXkFqcGdeQXVyNDUzOTQ5MjY@._V1_.jpg" }
    backdrop_url { "https://m.media-amazon.com/images" }
    imdb_id { "3782" }
  end

  factory :genre do
    name { "Horror" }
  end
end
