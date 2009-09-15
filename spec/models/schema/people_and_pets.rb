=begin

  These models are primarily intended for modeling presidential pets
  and are used in the Many To Many specs.

=end

Extlib::Inflection.plural_word("human","humans")

class Human
  include DataMapper::Resource
  property :id,           Serial
  property :first_name,   String, :nullable=>false
  property :middle_name,  String
  property :last_name,    String, :nullable=>false
  property :sex,          String, :nullable => false, :format => /^M|F|O$/
  property :dob,          DateTime

  has n, :ownerships, :child_key => [:human_id]
  has n, :pets, :through => :ownerships
end

class Ownership
  include DataMapper::Resource
  property :human_id, Integer, :key => true
  property :pet_id,   Integer,   :key => true

  belongs_to :pet, :child_key => [:pet_id]
  belongs_to :human, :child_key => [:human_id]
end

class Pet
  include DataMapper::Resource
  property :id, Serial
  property :name, String, :nullable => false
  property :species, String
  property :kind, String

  has n, :ownerships, :child_key => [:pet_id]
  has n, :humans, :through  => :ownerships
  has n, :toys, :through => Resource
end

class Toy
  include DataMapper::Resource
  property :id, Serial
  property :name, String, :length => 255
  property :price, Integer

  has n, :pets, :through => Resource
end

=begin
class Occupation
  include DataMapper::Resource
  property :human_id, Integer, :key => true
end
=end

=begin
  has n, :tacos, :spicy => true
  has n, :tacos, :conditions => {:spicy => true}
=end
