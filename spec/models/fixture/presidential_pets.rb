Pet.fixture(:bo){{  :name => "Bo", :species => "Canis familiaris", :kind=>"Portugese Water Dog"}}

Human.fixture(:barack){{  :first_name=>"Barack",  :last_name=>"Obama", :sex => "M" }}
Human.fixture(:michelle){{:first_name=>"Michelle",:last_name=>"Obama", :sex => "F" }}
Human.fixture(:malia){{   :first_name=>"Malia",   :last_name=>"Obama", :sex => "F" }}
Human.fixture(:sasha){{   :first_name=>"Sasha",   :last_name=>"Obama", :sex => "F" }}

Pet.fixture(:barney){{  :name => "Barney", :species => "Canis familiaris", :kind => "Scottish Terrier"}}
Pet.fixture(:beazly){{  :name => "Miss Beazley", :species => "Canis familiaris", :kind => "Scottish Terrier"}}

Human.fixture(:gwb){{       :first_name=>"George", :middle_name=>"Walker",:last_name=>"Bush", :sex => "M" }}
Human.fixture(:laura){{     :first_name=>"Laura", :last_name=>"Bush", :sex => "F" }}
Human.fixture(:jenna){{     :first_name=>"Jenna", :middle_name=>"Welch", :last_name=>"Bush", :sex => "F" }}
Human.fixture(:barb){{  :first_name=>"Barbra", :middle_name=>"Pierce", :last_name=>"Bush", :sex => "F", :dob=>"November 25, 1981" }}

Pet.fixture(:socks){{   :name => "Socks", :species => "Felis catus", :kind=> "American Shorthair"}}
Pet.fixture(:buddy){{   :name => "Buddy", :species => "Canis familiaris", :kind=> "Labrador Retreiver"}}
Pet.fixture(:seamus){{  :name => "Seamus", :species => "Canis familiaris", :kind=> "Labrador Retreiver"}}

Human.fixture(:bill){{    :first_name=>"William", :middle_name=>"Jefferson",:last_name=>"Clinton", :sex => "M" }}
Human.fixture(:hillary){{ :first_name=>"Hillary", :middle_name => "Rodham", :last_name=>"Clinton", :sex => "F" }}
Human.fixture(:chelsey){{ :first_name=>"Chelsey",:last_name=>"Clinton",     :sex => "F" }}

Pet.fixture(:millie){{ :name => "Millie", :species => "Canis familiaris", :kind=>"Springer Spaniel"}}

Human.fixture(:ghwb){{    :first_name=>"George", :middle_name=>"Herbert Walker", :last_name=>"Bush", :sex=>"M"}}
Human.fixture(:barbra){{  :first_name=>"Barbra", :middle_name=>"Pierce", :last_name=>"Bush", :sex => "F", :dob =>"June 8, 1925" }}

@bo = Pet.gen(:bo)
[:barack, :michelle, :malia, :sasha].each do |name| 
  person = Human.gen(name)
  person.pets = [@bo]
  person.save
  instance_variable_set("@"+name.to_s, person)
end

@barney = Pet.gen(:barney)
@beazly = Pet.gen(:beazly)
[:gwb, :laura, :jenna, :barb].each do |name| 
  person = Human.gen(name)
  person.pets = [@barney, @beazly]
  person.save
  instance_variable_set("@"+name.to_s, person)
end

@socks  = Pet.gen(:socks)
@buddy  = Pet.gen(:buddy)
@seamus = Pet.gen(:seamus)
[:bill, :hillary, :chelsey].each do |name| 
  person = Human.gen(name)
  person.pets = [@socks, @buddy, @seamus]
  person.save
  instance_variable_set("@"+name.to_s, person)
end

@millie = Pet.gen(:millie)
[:ghwb, :barbra].each do |name| 
  person = Human.gen(name)
  person.pets = [@millie]
  person.save
  instance_variable_set("@"+name.to_s, person)
end

Toy.fixture(:chewy){{   :name => "Chew Toy"}}
Toy.fixture(:squeaky){{ :name => "Squeaky Toy"}}
Toy.fixture(:bellball){{:name => "Bell Ball"}}
Toy.fixture(:ropeknot){{:name => "Rope Knot"}}
Toy.fixture(:catnip){{  :name => "Catnip Toy"}}
