# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# USERS
user1 = User.create({
  email: "joelalayongarcia@gmail.com",
  password: "12345678",
  full_name: "Joel Alayon"
})

# GENRES
Genre.create(name: 'Horror')
Genre.create(name: 'Science fiction')
Genre.create(name: 'Comedy')
Genre.create(name: 'Romance')
Genre.create(name: 'Adventure')

# MOVIES
movie1 = Movie.create({
  title: "The Lord of the Rings: The Fellowship of the Ring",
  tagline: "One ring to rule them all",
  overview: "The future of civilization rests in the fate of the One Ring, which has been lost for centuries. Powerful forces are unrelenting in their search for it. But fate has placed it in the hands of a young Hobbit named Frodo Baggins (Elijah Wood), who inherits the Ring and steps into legend. A daunting task lies ahead for Frodo when he becomes the Ringbearer - to destroy the One Ring in the fires of Mount Doom where it was forged." ,
  release_date: "2001-01-12",
  poster_url: "https://m.media-amazon.com/images/M/MV5BN2EyZjM3NzUtNWUzMi00MTgxLWI0NTctMzY4M2VlOTdjZWRiXkEyXkFqcGdeQXVyNDUzOTQ5MjY@._V1_.jpg",
  backdrop_url: "https://m.media-amazon.com/images",
  imdb_id: "3782"
})
movie2 = Movie.create(
{
  title: "The Lord of the Rings: The Two Towers",
  tagline: "A New Power Is Rising. The Battle for Middle-earth Begins! The fellowship is broken.",
  overview: "The sequel to the Golden Globe-nominated and AFI Award-winning The Lord of the Rings: The Fellowship of the Ring, The Two Towers follows the continuing quest of Frodo (Elijah Wood) and the Fellowship to destroy the One Ring. Frodo and Sam (Sean Astin) discover they are being followed by the mysterious Gollum. Aragorn (Viggo Mortensen), the Elf archer Legolas and Gimli the Dwarf encounter the besieged Rohan kingdom, whose once great King Theoden has fallen under Saruman's deadly spell.",
  release_date: "2003-01-03",
  poster_url: "https://images-na.ssl-images-amazon.com/images/I/81eqQvveI6L._AC_SY741_.jpg",
  backdrop_url: "https://images-na.ssl-images-amazon.com/images/",
  imdb_id: "8393"
}
)
video1 = Video.create({
  size: 178131,
  format: "Mp4",
  url: "www.fakeurl.com"
})

movie2.update(videos: [video1])

# LISTS
list1 = List.create(
  name: "Joel List",
  description: "A movies list",
  public: true,
  user_id: user1.id
)

list2 = List.create(
  name: "Joel List 2",
  description: "A movies list 2",
  public: false,
  user_id: user1.id
)

# UPDATE USER1 LISTS
# user1.update(lists: [list1, list2])

#UPDATE LISTS
# list1.update(user_id: [1])
# list1.update(movies: [movie1])

# list2.update(user_id: [1])
# list2.update(movies: [movie2])
