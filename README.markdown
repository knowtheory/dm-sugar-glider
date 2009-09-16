# dm-sugar-glider

## DISCLAIMER

This is ALPHA software, and is not yet complete.  Currently block matching only works with
properties on the model being queried.  Relationship/Path targeting is pending.  SugarGlider
also requires 

## Abstract
SugarGlider is an end user query interface for [DataMapper](http://www.datamapper.org).  It 
retains backwards-compatibility with [DataMapper](http://www.datamapper.org)'s existing query 
interface (condition hashes), and adds the capability to query using nested blocks, inspired by
[Thoughtbot's Squirrel library](http://www.thoughtbot.com/projects/squirrel/).

## Description

## Usage
The following are all equivalent queries:

	Human.all(:last_name => "Obama", :first_name => /a/)
	Human.all(:last_name => "Obama"){ first_name =~ /a/}
	Human.all{ last_name == "Obama";  first_name =~ /a/}

Additionally SugarGlider adds functionality which is not exposed through the hash query interface
namely, nested conditions, and logical ORs as well as logical ANDs:

	Human.any{ first_name =~ /ar/; sex == "F" } # => Barack Obama + ALL women
	Human.all{ first_name =~ /ar/; sex == "F" } # => Hillary Clinton, Barbra Bush, Barb Bush
	
	Human.any{ last_name == "Obama"; all{ last_name == "Bush"; sex == "F"}} # => The Obama family, and all the Bush women.
	Human.all{ sex == "F"; any{ last_name == "Clinton"; last_name == "Bush"}} # => Women from either the Bushes or Clintons

## Copyright

Copyright (c) 2009 Ted Han. See LICENSE for details.
