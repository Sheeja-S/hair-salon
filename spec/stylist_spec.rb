require('rspec')
require('pg')
require('stylist')

DB = PG.connect({:dbname => 'hair_salon_test'})

RSpec.configure do |config|
  config.after(:each) do
    DB.exec("DELETE FROM stylists *;")
  end
end

describe(Stylist) do
  describe(".all") do
    it("starts off with no stylists") do
      expect(Stylist.all()).to(eq([]))
    end
  end

describe('#name') do
  it("returns the name of a stylist") do
    stylist = Stylist.new(:name => 'Brian', :id => nil)
    expect(stylist.name).to(eq('Brian'))
  end
end

describe('#id') do
  it("sets its ID when you save it") do
    stylist = Stylist.new({:name => "Brian", :id => nil})
    stylist.save()
    expect(stylist.id()).to(be_an_instance_of(Fixnum))
  end
end

describe('#save') do
  it("returns an array of stylists") do
    stylist = Stylist.new(:name => 'Brian', :id => nil)
    stylist.save()
    expect(Stylist.all()).to(eq([stylist]))
  end
end

describe('#==') do
  it('is the same stylist if they have the same name and id') do
    stylist1 = Stylist.new({:name => 'Brian', :id => nil})
    stylist2 = Stylist.new({:name => 'Brian',
    :id => nil})
    expect(stylist1).to(eq(stylist2))
  end
end

describe(".find") do
  it('returns the stylist with a given id') do
    test_stylist = Stylist.new(:name => 'Brian', :id => 1)
    test_stylist.save()
    expect(Stylist.find(test_stylist.id())).to(eq(test_stylist))
  end
end

describe("#clients") do
  it('returns a list of clients for a specific stylist') do
    test_stylist = Stylist.new(:name => 'Brian', :id => nil)
    test_stylist.save()
    test_client = Client.new({:name => 'Julie', :stylist_id => test_stylist.id()})
    test_client.save()
    test_client2 = Client.new({:name => 'Sheeja', :stylist_id => test_stylist.id()})
    test_client2.save()
    expect(test_stylist.clients()).to(eq([test_client,test_client2]))
  end
end

describe('#update') do
  it("lets you update stylists in the databse") do
    stylist = Stylist.new({:name => "Brian", :id => nil})
    stylist.save()
    stylist.update({:name => "Steve"})
    expect(stylist.name()).to(eq("Steve"))
  end
end

describe("#delete") do
  it("lets you delete stylists from the database") do
    stylist = Stylist.new({:name => "Brian", :id => nil})
    stylist.save()
    stylist2 = Stylist.new({:name => "Steve", :id => nil})
    stylist2.save()
    stylist.delete()
    expect(Stylist.all()).to(eq([stylist2]))
  end

  it("deletes a stylist's client from the database") do
    stylist = Stylist.new({:name => "Brian", :id => nil})
    stylist.save()
    client = Client.new({:name => "Sheeja", :stylist_id => stylist.id()})
    client.save()
    client2 = Client.new({:name => "Julie", :stylist_id => stylist.id()})
    client2.save()
    stylist.delete()
    expect(Client.all()).to(eq([]))
  end
  end
end
