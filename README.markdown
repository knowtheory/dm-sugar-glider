# dm-sugar-glider

## DISCLAIMER

This is ALPHA software, and is not yet complete.  Currently block matching only works with
properties on the model being queried.  Relationship/Path targeting is pending.

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

## Copyright

Copyright (c) 2009 Ted Han. See LICENSE for details.
