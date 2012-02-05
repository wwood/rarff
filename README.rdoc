= rarff

http://adenserparlance.blogspot.com/2007/01/rarff-simple-arff-library-in-ruby.html

== DESCRIPTION:

Rarff is a Ruby library for dealing with Attribute-Relation File Format (ARFF) files. ARFF files are used to specify data sets for data mining and machine learning.


== FEATURES/PROBLEMS:

=== FEATURES
* Missing values - '?' are handled in creation of ARFF files

=== PROBLEMS
* Spaces or quotes in nominal types
* Commas in quoted attributes or in nominal types
* Add error checking/validation
* Creation of sparse ARFF files
* Dates - do some work to create, translate, and interpret date format strings.

== SYNOPSIS:

    arff_file_str = <<-END_OF_ARFF_FILE
@RELATION MyCoolRelation
@ATTRIBUTE Attr0 NUMERIC
@ATTRIBUTE subject STRING
@ATTRIBUTE Attr2 NUMERIC
@ATTRIBUTE Attr3 STRING
@ATTRIBUTE birthday DATE "yyyy-MM-dd HH:mm:ss"
@DATA
1.4, 'foo bar', 5, baz, "1900-08-08 12:12:12"
20.9, ruby, 46, rocks, "2005-10-23 12:12:12"
0, ruby, 46, rocks, "2001-02-19 12:12:12"
68.1, stuff, 728, 'is cool', "1974-02-10 12:12:12"
    END_OF_ARFF_FILE

    arff_file_str.gsub!(/\n$/, '')

    instances = [ [1.4, 'foo bar', 5, 'baz', "1900-08-08 12:12:12"],
      [20.9, 'ruby', 46, 'rocks', "2005-10-23 12:12:12"],
      [0, 'ruby', 46, 'rocks', "2001-02-19 12:12:12"],
      [68.1, 'stuff', 728, 'is cool', "1974-02-10 12:12:12"]]

    rel = Rarff::Relation.new('MyCoolRelation')
    rel.instances = instances
    rel.attributes[1].name = 'subject'
    rel.attributes[4].name = 'birthday'
    rel.attributes[4].type = 'DATE "yyyy-MM-dd HH:mm:ss"'

    #               puts "rel.to_arff:\n(\n#{rel.to_arff}\n)\n"
    assert_equal(arff_file_str, rel.to_arff, "Arff creation test failed.")

== REQUIREMENTS:

== INSTALL:

* sudo gem install wwood-rarff

== LICENSE:

Copyright (c) 2008 Andy Payne
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

        * Redistributions of source code must retain the above copyright notice,
        this list of conditions and the following disclaimer.
        * Redistributions in binary form must reproduce the above copyright notice,
        this list of conditions and the following disclaimer in the
        documentation and/or other materials provided with the distribution.
        * Neither the name of the COPYRIGHT OWNER nor the names of its contributors
        may be used to endorse or promote products derived from this software
        without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.




