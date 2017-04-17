require("sinatra")
require("sinatra/reloader")
also_reload("lib/**/*.rb")
require("./lib/client")
require("./lib/stylist")
require('pg')
require('pry')


DB = PG.connect({:dbname => "hair_salon"})

get("/") do
  erb(:index)
end

get("/stylists/new") do
   erb(:stylist_form)
 end

 post("/stylists") do
   name = params.fetch("name")
   stylist = Stylist.new({:name => name, :id => nil})
   stylist.save()
   erb(:success)
 end

 get('/stylists') do
   @stylists = Stylist.all()
   erb(:stylists)
 end

get("/stylists/:id") do
  @stylist = Stylist.find(params.fetch('id').to_i())
  @stylists = Stylist.all()
  erb(:stylist)
end

post("/clients") do
  name = params.fetch("name")
  stylist_id = params.fetch("stylist_id").to_i()
  @stylist = Stylist.find(stylist_id)
  @client = Client.new({:name => name, :stylist_id => stylist_id, :id => nil})
  @client.save()
  erb(:client_success)
end

get("/stylists/:id/edit") do
  @stylist = Stylist.find(params.fetch("id").to_i())
  erb(:stylist_edit)
end

patch("/stylists/:id") do
  name = params.fetch("name")
  @stylist = Stylist.find(params.fetch("id").to_i())
  @stylists = Stylist.all()
  @stylist.update({:name => name})
  redirect to ("/stylists/#{params.fetch("id").to_i()}")
end

delete("/stylists/:id") do
@stylist = Stylist.find(params.fetch("id").to_i())
@stylist.delete()
@stylists = Stylist.all()
erb(:index)
end

get("/clients/:id/edit") do
 @client = Client.find(params.fetch("id").to_i())
 erb(:client_edit)
end

patch("/clients/:id") do
   name = params.fetch("name")
   @client = Client.find(params.fetch("id").to_i())
   stylist_id = @client.stylist_id()
   @client.update({:name=>name})
   @stylist = Stylist.find(stylist_id)
   redirect to ("/stylists")
end

delete("/clients/:id") do
@client = Client.find(params.fetch("id").to_i())
@client.delete()
@clients = Client.all()
redirect to ("/")
end
