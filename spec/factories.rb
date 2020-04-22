FactoryBot.define do
  factory :movie do
    title { "MyString" }
    tagline { "MyString" }
    overview { "MyString" }
    release_date { "2020-04-21" }
    poster_url { "MyString" }
    backdrop_url { "MyString" }
    imdb_id { "MyString" }
  end

  factory :genre do
    name { "MyString" }
  end
end