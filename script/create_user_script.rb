require 'net/http'
require 'uri'
require 'json'

MOOVIE_API_URL = "http://localhost:3001/users"

puts "*Ingrese su nombre completo"
puts '==============================================================='
@full_name = gets.chomp
puts '==============================================================='
puts "*Ingrese su email"
puts '==============================================================='
@email = gets.chomp
puts '==============================================================='
puts "*Ingrese una contraseña"
puts '==============================================================='
@password = gets.chomp
puts '==============================================================='

uri = URI.parse(MOOVIE_API_URL)
request = Net::HTTP::Post.new(uri)

request.set_form_data(
  "email" => @email,
  "full_name" => @full_name,
  "password" => @password
)

req_options = {
  use_ssl: uri.scheme == "https",
}

response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
  http.request(request)
end

data = JSON.parse(response.body)

if data['data']['email'] == ["has already been taken"]
  puts 'Email: The email has already been taken'
elsif data['data']['email'] == ["is invalid"]
  puts 'Email: The email format is not valid'
else
  puts 'Email: Correct'
end

if data['data']['password'] == ["is too short (minimum is 6 characters)"]
  puts 'Password: Your password is too short(minimum is 6 characters)'
else
  puts 'Password: Correct'
end
puts '==============================================================='

if response.code == "422"
  puts '--Please check your fields--'
elsif response.code == "202"
  puts '++The user has been created successfully++'
else
  puts '\Please check your connection/'
end

puts '==============================================================='