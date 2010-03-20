Pet.fixture(:bo){{
  :name => "Bo", :species => "Canis familiaris", :kind=>"Portugese Water Dog"
}}

Human.fixture(:barack){{
  :first_name=>"Barack",  :middle_name=>"Hussein",  :last_name=>"Obama", :sex => "M", :dob=>"August 4, 1961"
}}
Human.fixture(:michelle){{
  :first_name=>"Michelle", :middle_name=>"LaVaughn Robinson", :last_name=>"Obama", :sex => "F", :dob=>"January 17, 1964" 
}}
Human.fixture(:malia){{
  :first_name=>"Malia", :middle_name=>"Ann",   :last_name=>"Obama", :sex => "F", :dob=>"July 4, 1998" 
}}
Human.fixture(:sasha){{
  :first_name=>"Natasha", :last_name=>"Obama", :sex => "F", :dob=>"June 8, 2001" 
}}

Pet.fixture(:barney){{
  :name => "Barney", :species => "Canis familiaris", :kind => "Scottish Terrier"
}}
Pet.fixture(:beazly){{
  :name => "Miss Beazley", :species => "Canis familiaris", :kind => "Scottish Terrier"
}}

Human.fixture(:gwb){{
  :first_name=>"George", :middle_name=>"Walker",:last_name=>"Bush", :sex => "M", :dob=>"July 6, 1946" 
}}
Human.fixture(:laura){{
  :first_name=>"Laura", :middle_name=>"Lane Welch", :last_name=>"Bush", :sex => "F", :dob=>"November 4, 1946" 
}}
Human.fixture(:jenna){{
  :first_name=>"Jenna", :middle_name=>"Welch", :last_name=>"Hager", :sex => "F", :dob=>"November 25, 1981"
}}
Human.fixture(:barb){{
  :first_name=>"Barbra", :middle_name=>"Pierce", :last_name=>"Bush", :sex => "F", :dob=>"November 25, 1981" 
}}

Pet.fixture(:socks){{
  :name => "Socks", :species => "Felis catus", :kind=> "American Shorthair"
}}
Pet.fixture(:buddy){{
  :name => "Buddy", :species => "Canis familiaris", :kind=> "Labrador Retreiver"
}}
Pet.fixture(:seamus){{
  :name => "Seamus", :species => "Canis familiaris", :kind=> "Labrador Retreiver"
}}

Human.fixture(:bill){{
  :first_name=>"William", :middle_name=>"Jefferson",:last_name=>"Clinton", :sex => "M", :dob=>"August 19, 1946" 
}}
Human.fixture(:hillary){{
  :first_name=>"Hillary", :middle_name => "Rodham", :last_name=>"Clinton", :sex => "F", :dob=>"October 26, 1947" 
}}
Human.fixture(:chelsey){{
  :first_name=>"Chelsey", :last_name=>"Clinton",     :sex => "F", :dob=>"February 27, 1980" 
}}

Pet.fixture(:millie){{
  :name => "Millie", :species => "Canis familiaris", :kind=>"Springer Spaniel"
}}

Human.fixture(:ghwb){{
  :first_name=>"George", :middle_name=>"Herbert Walker", :last_name=>"Bush", :sex=>"M", :dob=>"June 12, 1924"
}}
Human.fixture(:barbra){{
  :first_name=>"Barbra", :middle_name=>"Pierce", :last_name=>"Bush", :sex => "F", :dob =>"June 8, 1925" 
}}

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

Toy.fixture(:chewy){{
     :name => "Chew Toy"
}}
Toy.fixture(:squeaky){{
   :name => "Squeaky Toy"
}}
Toy.fixture(:bellball){{
  :name => "Bell Ball"
}}
Toy.fixture(:ropeknot){{
  :name => "Rope Knot"
}}
Toy.fixture(:catnip){{
    :name => "Catnip Toy"
}}
