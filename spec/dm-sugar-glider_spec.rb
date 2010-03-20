require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe DataMapper do
  describe DataMapper::Query do
    describe "Group" do
      describe "Closure Axiom" do
        # Closure must ensure that output of our method is ALWAYS a query
        # if the arguments are two queries.
        it "requires that TWO QUERIES ENTER, ONLY ONE QUERY LEAVES" do
          q1 = DataMapper::Query.new(Human.repository,Human)
          q2 = DataMapper::Query.new(Human.repository,Human)
          q1.merge(q2).should be_kind_of(DataMapper::Query)
          q2.merge(q1).should be_kind_of(DataMapper::Query)
        end
      end
      
      describe "Associative Axiom" do
        before do
          @condition1 = DataMapper::Query::Conditions::EqualToComparison.new(Human.sex, 'F')
          @condition2 = DataMapper::Query::Conditions::RegexpComparison.new(Human.first_name, /a/)
#          @condition3 = DataMapper::Query::Conditions::GreaterThanOrEqualComparison.new()
#          @condition4 = DataMapper::Query::Conditions::
#          @condition5 = DataMapper::Query::Conditions::
#          @condition6 = DataMapper::Query::Conditions::
        end
      end
      
      describe "Identity Axiom" do
        before do
          @identity = DataMapper::Query.new(Human.repository,Human)
          @query = DataMapper::Query.new(Human.repository,Human, {:first_name => /a/})
          # Note: these tests should be run with a wide variety of Queries, with different attributes
        end
      
        it "should not modify a query when merging into the Identity Query" do
          @identity.merge(@query).should be_eql(@query)
        end
        
        it "should not modify a query when the Identity Query is merged into it" do
          @query.merge(@identity).should be_eql(@query)
        end
      end

      describe "Inverse Axiom" do
      end
    end
    
    describe "#dup" do
      it "should return a result that is #== to the original" do
        or_op = DataMapper::Query::Conditions::OrOperation.new
        and_op = DataMapper::Query::Conditions::AndOperation.new
          or_op << DataMapper::Query::Conditions::Comparison.new(:eql, Human.last_name, "Obama")
          or_op << DataMapper::Query::Conditions::Comparison.new(:eql, Human.last_name, "Clinton")
        and_op << DataMapper::Query::Conditions::Comparison.new(:eql, Human.sex, "M")
        and_op << or_op
        
        q = DataMapper::Query.new(Human.repository,Human, :conditions=>and_op)
        q.conditions.should == and_op
        q.dup.should == q
      end
    end
    
    describe "#merge" do
      it do
        conditions  = DataMapper::Query::Conditions::AndOperation.new 
        conditions << DataMapper::Query::Conditions::Comparison.new(:eql, Human.sex, "M")
        query       = DataMapper::Query.new(Human.repository, Human, :conditions => conditions)
        empty_query = DataMapper::Query.new(Human.repository, Human)
        query.merge(empty_query).should == query
        empty_query.merge(query).should == query
      end

      it "should suborn the query conditions from the latter query into the former query" do
        op1 =  DataMapper::Query::Conditions::OrOperation.new
        op1 << DataMapper::Query::Conditions::Comparison.new(:eql, Human.last_name, "Obama")

        op2 =  DataMapper::Query::Conditions::AndOperation.new
        op2 << DataMapper::Query::Conditions::Comparison.new(:eql, Human.last_name, "Clinton")
        op2 << DataMapper::Query::Conditions::Comparison.new(:eql, Human.sex, "M")
        
        q1 = DataMapper::Query.new(Human.repository,Human, :conditions=>op1) # => Obamas
        q2 = DataMapper::Query.new(Human.repository,Human, :conditions=>op2) # => Bill Clinton
        q1.merge(q2).conditions.should == DataMapper::Query::Conditions::AndOperation.new.merge([op1.dup, op2])
      end
    end
  end
end

describe DataMapper::SugarGlider do
  # TODO: this module should be runnable against all the main dm-core specs.
  
  describe "User Interface" do
    it "should allow querying with mixed conditions" do
      original  = Human.all(:last_name => "Obama", :first_name => /a/)
      mixed     = Human.all(:last_name => "Obama"){ first_name =~ /a/}
      block     = Human.all{ last_name == "Obama";  first_name =~ /a/}
      mixed.query.should == original.query
      block.query.should == original.query
    end
    
    it "should allow chaining query blocks" do
      (Human.all{ last_name == "Obama"}.all{ first_name =~ /a/}).query.conditions.should == Human.all{ last_name == "Obama";  first_name =~ /a/}.query.conditions
      Human.all{ last_name == "Obama"}.all{ first_name =~ /a/}.should == Human.all{ last_name == "Obama";  first_name =~ /a/}
    end
    
    describe "Model.any" do
      it do 
        women_and_barack = Human.any{ last_name == "Obama"; sex == "F" }
        women = Human.all(:sex => "F")
        obamas = Human.all(:last_name => "Obama")
        (women_and_barack & women).should == women
        (women_and_barack & obamas).should == obamas
        (women_and_barack - women - obamas).should == []
      end
    end
  end
  
  describe "Query Construction" do
    
  end
  
  describe "Querying Relationships" do
    it "" do
      Human.any{ pets.species == "Felis catus"; all{ first_name == "Barbra"; dob == "June 8, 1925" }}
    end
  end
end
=begin
#====================================
# SQUIB
#====================================

Human.all{ last_name == "Obama" }
Human.all{ first_name =~ /ar/; sex == "F" } # => Hillary, Barbra, Barb
Human.any{ first_name =~ /ar/; sex == "F" } # => Barack + ALL women

#====================================

Human.any{ first_name =~ /ar/; sex == "F"} # => All women, and Barack
# Current Solution:
  conditions = DataMapper::Query::Conditions::OrOperation.new <<
                DataMapper::Query::Conditions::Comparison.new(:regexp,Human.first_name,/ar/) << 
                DataMapper::Query::Conditions::Comparison.new(:eql, Human.sex,"F")

  q = DataMapper::Query.new(Human.repository,Human)
  q.conditions << conditions
  #q.instance_variable_set("@conditions", conditions)
  DataMapper::Collection.new(q).map{ |h| h.first_name }

#====================================

Pet.any{ kind == ["Portuguese Water Dog", "Labrador Retreiver"] }
Pet.all{ species == "Felis catus"; humans == Human.first(:first_name => "William", :last_name =>"Clinton") }

DataMapper::Query.new(Human.repository,Human,{:first_name => /ar/})
Human.all(:first_name => /ar/)
Human.any{ pets.species == "Felis catus"; all{ first_name == "Barbra"; dob == "June 8, 1925" }}

Human.any{ sex == "M"; all{ first_name == "Barbra"; dob == "June 8, 1925" }}

#====================================

or_op = DataMapper::Query::Conditions::OrOperation.new
and_op = DataMapper::Query::Conditions::AndOperation.new
  and_op << DataMapper::Query::Conditions::Comparison.new(:eql, Human.first_name, "Barbra")
  and_op << DataMapper::Query::Conditions::Comparison.new(:eql, Human.dob, "June 8, 1925")
or_op << DataMapper::Query::Conditions::Comparison.new(:eql, Human.sex, "M")
or_op << and_op
=begin
  #<DataMapper::Query::Conditions::OrOperation @operands=[
    #<DataMapper::Query::Conditions::EqualToComparison @subject=#<DataMapper::Property @model=Human @name=:sex> value"M" loaded_value"M", 
    #<DataMapper::Query::Conditions::AndOperation @operands=[
      #<DataMapper::Query::Conditions::EqualToComparison @subject=#<DataMapper::Property @model=Human @name=:first_name> value"Barbra" loaded_value"Barbra", 
      #<DataMapper::Query::Conditions::EqualToComparison @subject=#<DataMapper::Property @model=Human @name=:dob> value#<DateTime: 4848619/2,0,2299161 @loaded_value=#<DateTime: 4848619/2,0,2299161>
      ]
    ]
=end
=begin
q = DataMapper::Query.new(Human.repository,Human)
q.conditions # => #<DataMapper::Query::Conditions::AndOperation @operands=[]>
q.instance_variable_set("@conditions", or_op)
q.valid? # => true
Human.all(q) # => returns ALL humans.  identical to Human.all
# ~ (0.000111) SET sql_auto_is_null = 0
# ~ (0.000301) SET SESSION sql_mode = 'ANSI,NO_AUTO_VALUE_ON_ZERO,NO_DIR_IN_CREATE,NO_ENGINE_SUBSTITUTION,NO_UNSIGNED_SUBTRACTION,TRADITIONAL'
# ~ (0.000422) SELECT "id", "first_name", "middle_name", "last_name", "sex", "dob" FROM "humans" ORDER BY "id"
Human.all(q) == Human.all
# ~ (0.000129) SELECT "id", "first_name", "middle_name", "last_name", "sex", "dob" FROM "humans" ORDER BY "id"
# ~ (0.000103) SELECT "id", "first_name", "middle_name", "last_name", "sex", "dob" FROM "humans" ORDER BY "id"
# => true
DataMapper.repository.adapter.send(:conditions_statement, or_op)
# => ["\"sex\" = ? OR (\"first_name\" = ? AND \"dob\" = ?)", ["M", "Barbra", #<DateTime: 4848619/2,0,2299161>]]

sql, args = DataMapper.repository.adapter.send(:conditions_statement, or_op); sql = "select * from humans where #{q}"; Human.find_by_sql([sql,*args])
# ~ (0.000085) select * from humans where "sex" = 'M' OR ("first_name" = 'Barbra' AND "dob" = '1925-06-08 00:00:00')
# => [#<Human @id=1 @first_name="Barack" @middle_name=nil @last_name="Obama" @sex="M" @dob=nil>, 
#     #<Human @id=5 @first_name="George" @middle_name="Walker" @last_name="Bush" @sex="M" @dob=nil>, 
#     #<Human @id=9 @first_name="William" @middle_name="Jefferson" @last_name="Clinton" @sex="M" @dob=nil>, 
#     #<Human @id=12 @first_name="George" @middle_name="Herbert Walker" @last_name="Bush" @sex="M" @dob=nil>, 
#     #<Human @id=13 @first_name="Barbra" @middle_name="Pierce" @last_name="Bush" @sex="F" @dob=#<DateTime: 7272929/3,-1/6,2299161>>]

or_op = DataMapper::Query::Conditions::OrOperation.new
and_op = DataMapper::Query::Conditions::AndOperation.new
  or_op << DataMapper::Query::Conditions::Comparison.new(:eql, Human.last_name, "Obama")
  or_op << DataMapper::Query::Conditions::Comparison.new(:eql, Human.last_name, "Clinton")
and_op << DataMapper::Query::Conditions::Comparison.new(:eql, Human.sex, "M")
and_op << or_op

q = DataMapper::Query.new(Human.repository,Human)
q.conditions # => #<DataMapper::Query::Conditions::AndOperation @operands=[]>
q.instance_variable_set("@conditions", and_op)
q.valid? # => true
Human.all(q) == Human.all # => true
DataMapper.repository.adapter.send(:conditions_statement, and_op) 
#=> [""sex" = ? AND ("last_name" = ? OR "last_name" = ?)", ["M", "Obama", "Clinton"]]

sql, args = DataMapper.repository.adapter.send(:conditions_statement, and_op); sql = "select * from humans where #{sql}"; Human.find_by_sql([sql,*args])
# ~ (0.000447) select * from humans where "sex" = 'M' AND ("last_name" = 'Obama' OR "last_name" = 'Clinton')
# => [#<Human @id=1 @first_name="Barack" @middle_name=nil @last_name="Obama" @sex="M" @dob=nil>, 
#     #<Human @id=9 @first_name="William" @middle_name="Jefferson" @last_name="Clinton" @sex="M" @dob=nil>]
DataMapper.repository.adapter.send(:select_statement,q)
# => ["SELECT "id", "first_name", "middle_name", "last_name", "sex", "dob" FROM "humans" WHERE "sex" = ? AND ("last_name" = ? OR "last_name" = ?) ORDER BY "id"", ["M", "Obama", "Clinton"]]
sql = DataMapper.repository.adapter.send(:select_statement, q); Human.find_by_sql([sql.first,*sql.last])
# ~ (0.000480) SELECT "id", "first_name", "middle_name", "last_name", "sex", "dob" FROM "humans" WHERE "sex" = 'M' AND ("last_name" = 'Obama' OR "last_name" = 'Clinton') ORDER BY "id"
# => [#<Human @id=1 @first_name="Barack" @middle_name=nil @last_name="Obama" @sex="M" @dob=nil>, 
#     #<Human @id=9 @first_name="William" @middle_name="Jefferson" @last_name="Clinton" @sex="M" @dob=nil>]

DataMapper::Collection.new(q) # fucking works, it's the goddamned DataMapper::Query#update method that's fucking everything up.
# => [#<Human @id=1 @first_name="Barack" @middle_name=nil @last_name="Obama" @sex="M" @dob=nil>, 
#     #<Human @id=9 @first_name="William" @middle_name="Jefferson" @last_name="Clinton" @sex="M" @dob=nil>]


q = DataMapper::Query.new(Human.repository,Human)
q.instance_variable_set("@conditions", DataMapper::Query::Conditions::Comparison.new(:eql, Human.last_name, "Obama"))
DataMapper::Collection.new(q)

q = DataMapper::Query.new(Human.repository,Human,{:conditions=> DataMapper::Query::Conditions::Comparison.new(:eql, Human.last_name, "Obama")})
q = DataMapper::Query.new(Human.repository,Human,{:conditions=> DataMapper::Query::Conditions::Operation.new(:or)})
q = DataMapper::Query.new(Human.repository,Human,{:conditions=> DataMapper::Query::Conditions::Operation.new(:and)})
q = DataMapper::Query.new(Human.repository,Human,{:conditions=> DataMapper::Query::Conditions::Operation.new(:not)})
q = DataMapper::Query.new(Human.repository,Human,{:conditions=> ""})

or_op = DataMapper::Query::Conditions::OrOperation.new
  or_op << DataMapper::Query::Conditions::Comparison.new(:eql, Human.last_name, "Obama")
  or_op << DataMapper::Query::Conditions::Comparison.new(:eql, Human.last_name, "Clinton")
q1 = DataMapper::Query.new(Human.repository,Human,{:conditions=>or_op})
q2 = DataMapper::Query.new(Human.repository,Human,{:conditions=>DataMapper::Query::Conditions::Comparison.new(:eql, Human.sex, "M")})
(q1.merge(q2)).conditions # omg it's just overwriting them.

Human.all{ sex == "M" }.any{ last_name == "Obama"; last_name == "Clinton" }.query == 
Human.all{ sex == "M"; any { last_name == "Obama"; last_name == "Clinton" } }.query

# ==========================

Human.all(DataMapper::Query.new(Human.repository, Human, {:links=>Human.pets.relationships}))

# ========================== Fail during update to 10.0.1 :( :( :( :( :( :(

or_op = DataMapper::Query::Conditions::OrOperation.new
and_op = DataMapper::Query::Conditions::AndOperation.new
  or_op << DataMapper::Query::Conditions::Comparison.new(:eql, Human.last_name, "Obama")
  or_op << DataMapper::Query::Conditions::Comparison.new(:eql, Human.last_name, "Clinton")
and_op << DataMapper::Query::Conditions::Comparison.new(:eql, Human.sex, "M")
and_op << or_op

q = DataMapper::Query.new(Human.repository,Human, :conditions => and_op)

q.update(DataMapper::Query.new(Human.repository,Human)) == q # true
Human.all(q).query == q # FALSE FFS WHY IS THIS FALSE.  No longer false yay!

Human.send(:scoped_query, q) == q # also false D: D: D:

q.dup == q # => false WHY?! WHY!? WHY!?

# ==========================

Pet.all{ species == "Felis catus"; humans == Human.first(:first_name => "William", :last_name =>"Clinton") }

and_op = DataMapper::Query::Conditions::AndOperation.new
and_op << DataMapper::Query::Conditions::Comparison.new(:eql, Pet.species, "Canis Majoris")
and_op << DataMapper::Query::Conditions::Comparison.new(:eql, Human.last_name, "Clinton")

q = DataMapper::Query.new(Pet.repository, Pet, {:conditions=>and_op})
Pet.all(q)

Pet.all(DataMapper::Query::Path.new([Pet.relationships[:humans]], :last_name) => "Clinton")

# ============================ Query Validity

or_op = DataMapper::Query::Conditions::OrOperation.new
and_op = DataMapper::Query::Conditions::AndOperation.new
  or_op << DataMapper::Query::Conditions::Comparison.new(:eql, Human.last_name, "Obama")
  or_op << DataMapper::Query::Conditions::Comparison.new(:eql, Human.last_name, "Clinton")
and_op << DataMapper::Query::Conditions::Comparison.new(:eql, Human.sex, "M")
and_op << or_op

q = DataMapper::Query.new(Human.repository,Human, :conditions => and_op)

Human.all(q)

=end
