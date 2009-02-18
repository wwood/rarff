# See the README file for more information.
$:.unshift File.join(File.dirname(__FILE__),'..','lib')
require 'test/unit'
require 'rarff'

class TestArffLib < Test::Unit::TestCase

  # Test creation of an arff file string.
  def test_arff_creation

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
  end
  #
  #  # Test creation of a sparse arff file string.
  #  def test_sparse_arff_creation
  #
  #    arff_file_str = <<-END_OF_ARFF_FILE
  #@RELATION MyCoolRelation
  #@ATTRIBUTE Attr0 NUMERIC
  #@ATTRIBUTE subject STRING
  #@ATTRIBUTE Attr2 NUMERIC
  #@ATTRIBUTE Attr3 STRING
  #@ATTRIBUTE birthday DATE "yyyy-MM-dd HH:mm:ss"
  #@DATA
  #{0 1.4, 1 'foo bar', 3 baz, 4 "1900-08-08 12:12:12"}
  #{0 20.9, 1 ruby, 2 46, 3 rocks, 4 "2005-10-23 12:12:12"}
  #{1 ruby, 2 46, 3 rocks, 4 "2001-02-19 12:12:12"}
  #{0 68.1, 1 stuff, 3 'is cool', 4 "1974-02-10 12:12:12"}
  #    END_OF_ARFF_FILE
  #
  #    arff_file_str.gsub!(/\n$/, '')
  #
  #    instances = [ [1.4, 'foo bar', 0, 'baz', "1900-08-08 12:12:12"],
  #      [20.9, 'ruby', 46, 'rocks', "2005-10-23 12:12:12"],
  #      [0.0, 'ruby', 46, 'rocks', "2001-02-19 12:12:12"],
  #      [68.1, 'stuff', 0, 'is cool', "1974-02-10 12:12:12"]]
  #
  #    rel = Rarff::Relation.new('MyCoolRelation')
  #    rel.instances = instances
  #    rel.attributes[1].name = 'subject'
  #    rel.attributes[4].name = 'birthday'
  #    rel.attributes[4].type = 'DATE "yyyy-MM-dd HH:mm:ss"'
  #
  #    #               puts "rel.to_arff(true):\n(\n#{rel.to_arff(true)}\n)\n"
  #    assert_equal( arff_file_str, rel.to_arff(true), "test_sparse_arff_creation.")
  #  end
  #
  #
  #  # Test parsing of an arff file.
  #  def test_arff_parse
  #    in_file = './test_arff.arff'
  #    rel = Rarff::Relation.new
  #    rel.parse(File.open(File.join(File.dirname(__FILE__),in_file)).read)
  #
  #    assert_equal(rel.instances[2][1], 3.2)
  #    assert_equal(rel.instances[7][4], 'Iris-setosa')
  #  end
  #
  #
  #  # Test parsing of sparse ARFF format
  #  def test_sparse_arff_parse
  #    in_file = './test_sparse_arff.arff'
  #    rel = Rarff::Relation.new
  #    rel.parse(File.open(File.join(File.dirname(__FILE__),in_file)).read)
  #
  #    assert_equal(13, rel.instances[0].size)
  #    assert_equal(0, rel.instances[0][1])
  #    assert_equal(7, rel.instances[0][3])
  #    assert_equal(2.4, rel.instances[1][1])
  #    assert_equal(0, rel.instances[1][2])
  #    assert_equal(19, rel.instances[1][12])
  #    assert_equal(6, rel.instances[2][6])
  #    assert_equal(0, rel.instances[3][12])
  #    #               puts "\n\nARFF: (\n#{rel.to_arff}\n)"
  #  end
  #
  def test_output_missing
    arff_file_str = <<-END_OF_ARFF_FILE
@RELATION MyCoolRelation
@ATTRIBUTE Attr0 NUMERIC
@ATTRIBUTE subject STRING
@ATTRIBUTE Attr2 NUMERIC
@ATTRIBUTE Attr3 STRING
@ATTRIBUTE birthday DATE "yyyy-MM-dd HH:mm:ss"
@DATA
?, 'foo bar', 5, baz, ?
20.9, ruby, 46, ?, "2005-10-23 12:12:12"
    END_OF_ARFF_FILE

    arff_file_str.gsub!(/\n$/, '')

    instances = [ [nil, 'foo bar', 5, 'baz', nil],
      [20.9, 'ruby', 46, nil, "2005-10-23 12:12:12"]]

    rel = Rarff::Relation.new('MyCoolRelation')
    rel.instances = instances
    rel.attributes[1].name = 'subject'
    rel.attributes[4].name = 'birthday'
    rel.attributes[4].type = 'DATE "yyyy-MM-dd HH:mm:ss"'

    #               puts "rel.to_arff:\n(\n#{rel.to_arff}\n)\n"
    assert_equal(arff_file_str, rel.to_arff, "missing data output failure")
  end
  
  def test_output_missing_undefined_first_row
    arff_file_str = <<-END_OF_ARFF_FILE
@RELATION MyCoolRelation
@ATTRIBUTE Attr0 NUMERIC
@ATTRIBUTE subject STRING
@ATTRIBUTE Attr2 NUMERIC
@ATTRIBUTE Attr3 NUMERIC
@ATTRIBUTE birthday DATE "yyyy-MM-dd HH:mm:ss"
@DATA
?, ?, ?, ?, ?
20.9, ruby, 46, ?, "2005-10-23 12:12:12"
    END_OF_ARFF_FILE

    arff_file_str.gsub!(/\n$/, '')

    instances = [ [nil, nil, nil, nil, nil],
      [20.9, 'ruby', 46, nil, "2005-10-23 12:12:12"]]

    rel = Rarff::Relation.new('MyCoolRelation')
    rel.instances = instances
    rel.attributes[1].name = 'subject'
    rel.attributes[4].name = 'birthday'
    rel.attributes[4].type = 'DATE "yyyy-MM-dd HH:mm:ss"'

    #               puts "rel.to_arff:\n(\n#{rel.to_arff}\n)\n"
    assert_equal(arff_file_str, rel.to_arff, "missing data from first line output failure")
  end
  
  def test_boolean
    arff_file_str = <<-END_OF_ARFF_FILE
@RELATION MyCoolRelation
@ATTRIBUTE Attr0 {false,true}
@DATA
true
    END_OF_ARFF_FILE

    arff_file_str.gsub!(/\n$/, '')

    instances = [ [true]]

    rel = Rarff::Relation.new('MyCoolRelation')
    rel.instances = instances

    #               puts "rel.to_arff:\n(\n#{rel.to_arff}\n)\n"
    assert_equal(arff_file_str, rel.to_arff, "missing data from first line output failure")   
  end
  
  def test_boolean_multipl
    arff_file_str = <<-END_OF_ARFF_FILE
@RELATION MyCoolRelation
@ATTRIBUTE Attr0 {false,true}
@ATTRIBUTE Attr1 {false,true}
@ATTRIBUTE Attr2 {false,true}
@DATA
true, false, true
true, true, true
    END_OF_ARFF_FILE

    arff_file_str.gsub!(/\n$/, '')

    instances = [ [true,false,true],[true,true,true]]

    rel = Rarff::Relation.new('MyCoolRelation')
    rel.instances = instances

    #               puts "rel.to_arff:\n(\n#{rel.to_arff}\n)\n"
    assert_equal(arff_file_str, rel.to_arff, "missing data from first line output failure")   
  end

  def test_strings_as_nominal
    arff_file_str = <<-END_OF_ARFF_FILE
@RELATION MyCoolRelation
@ATTRIBUTE Attr0 {two,one}
@ATTRIBUTE Attr1 {three,four}
@DATA
one, three
two, four
    END_OF_ARFF_FILE

    arff_file_str.gsub!(/\n$/, '')

    instances = [ ['one','three'],['two','four']]

    rel = Rarff::Relation.new('MyCoolRelation')
    rel.instances = instances
    rel.set_string_attributes_to_nominal

    #               puts "rel.to_arff:\n(\n#{rel.to_arff}\n)\n"
    assert_equal(arff_file_str, rel.to_arff, "test_strings_as_nominal")
  end
end



