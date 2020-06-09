FactoryBot.define do
  factory :user do
    email {"test@gmail.com"}
    password {"12345678"}
    full_name {"Joel Alayon"}
    photo_path {"www.url.com"}
  end

  factory :genre do
    name { "Horror" }
  end
end