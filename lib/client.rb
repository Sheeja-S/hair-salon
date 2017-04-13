
class Client
  attr_reader(:id, :name, :stylist_id)

  define_method(:initialize) do |attributes|
    @id = attributes.fetch(:id)
    @name = attributes.fetch(:name)
    @stylist_id = attributes.fetch(:stylist_id)
  end

  define_singleton_method(:all) do
    returned_clients = DB.exec("SELECT * FROM clients;")
    clients = []
    returned_clients.each() do |client|
      name = client.fetch("name")
      id = client.fetch('id').to_i()
      stylist_id = client.fetch("stylist_id").to_i()
      clients.push(Client.new({:id => id, :name => name, :stylist_id => stylist_id}))
    end
    clients
  end

  define_method(:find) do |id|
      result = DB.exec("SELECT * FROM clients WHERE id = #{id};")
      name = result.first.fetch('name')
      stylist_id = Integer(result.first.fetch('stylist_id'))
      Client.new({:id => id, :name => name, :stylist_id => stylist_id})
    end

  define_method(:save) do
    result = DB.exec("INSERT INTO clients (name, stylist_id) VALUES ('#{@name}',#{@stylist_id}) RETURNING id;")
    @id = result.first.fetch('id')
  end

  define_method(:==) do |another_client|
    self.id().==(another_client()) &&
    self.name().==(another_client.name()) &&
    self.stylist_id().==(another_client.stylist_id)
  end

  define_method(:update) do |attributes|
    DB.exec("UPDATE clients SET name = '#{name}' WHERE id = #{self.id()};")
  end

  define_method(:stylists) do
    results = DB.exec("SELECT * FROM stylists WHERE id = #{self.stylist_id};")
    name = results.first.fetch('name')
    result = Stylist.new({:name => name, :id => self.stylist_id})
    result
  end

  def delete
    DB.exec("DELETE FROM clients WHERE id = #{self.id};")
  end
end
