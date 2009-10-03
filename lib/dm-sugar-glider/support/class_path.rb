module ClassPather
  def to_class_path
    ClassPath.new(self)
  end
  
  alias_method :to_path, :to_class_path
  
  def outerclass
    to_class_path.outerclass
  end
end

class Class; include ClassPather; end
class Module; include ClassPather; end

=begin

  = ClassPath

  == Author
    Ted Han (knowtheory)
  
  == Description
    ClassPath's purpose is to provide a consistent way to manipulate Constant
    Class and Module paths.  It's primary use will likely be for library 
    implementors who write code which modifies user defined classes.
    
    Fundamentally ClassPaths are an array structure, and so the class is implemented
    as a subclass of Array.  Methods that do not map sensibly to a ClassPath (such as
    #delete, #flatten, #fill, etc)
  
  == Usage
    ClassPath provides iterators and some of the standard array manipulation
    methods.  If you've ever found yourself wanting to #pop off of the end of
    a Class path, well now you can.  Or if you've ever wondered why there wasn't
    an Class#outer_class method, to match Class#superclass, you've got one now!
    
  === Examples:
  
    DataMapper::Query::Conditions::Operation.outerclass # => #<ClassPath DataMapper::Query::Conditions>
    ClassPath.new("DataMapper::Query::Conditions") << "Operation" # => #<ClassPath DataMapper::Query::Conditions::Operation>
    path = DataMapper::Query::Conditions::Operation.to_class_path
    path.include? "Query" # => true
=end
class ClassPath < Array
  
  # ==========================================
  # Useful Overwritten Methods:
  # ==========================================
  def initialize(path); super(path.to_s.split("::")); end
  
  def to_s; self.join; end

  def inspect
    "#<#{self.class} #{self.to_s}>"
  end
  
  def ==(other);  other.class == self.class ? super : false end
  
  def eql?(other); other.class == self.class ? super : false ; end
  
  def include?(obj)
    const_string = obj.to_s
    super(const_string)
  end
  
  def <<(obj)
    self.constantize.const_get(obj)
    super
  end

  def concat(other)
    self.constantize.full_const_get(other)
    super
  end
  
  def join(seperator="::")
    super(seperator)
  end


  # ==========================================
  # ClassPath Specific Methods:
  # ==========================================
  def constantize
    Object.full_const_get(self.to_s)
  end
  
  def outerclass
    if self.size <= 1
      return nil
    else
      ClassPath.new(self[0,self.size-1]).constantize
    end
  end

  # ==========================================
  # Overwritten Methods of Dubious Use:
  # ==========================================
  def insert(index,object)
    unless index < self.size and index >= -self.size
      raise ArgumentError "Index can't have a larger magnitude than the number of nodes in the path"
    end
    Object.full_const_get((self[0..index-1] << object).join("::"))
    super
  end
  
  # ==========================================
  # Overwritten (Banned) Methods of No Use:
  # ==========================================
  class << self
    undef_method :[] if respond_to?(:[]) # disallow ClassPath["some","args"] constructor
  end
  [:&, :*, :+, :-, :assoc, :clear, :compact, :compact!, :delete, :delete_at, 
   :delete_if, :fill, :flatten, :flatten!, :nitems, :pack, :rassoc, :reject, 
   :reject!, :replace, :reverse, :reverse!, :select, :slice!, :sort!, :transpose, 
   :uniq, :uniq!, :zip, :|].each{ |name| undef_method name if respond_to?(name) }
end