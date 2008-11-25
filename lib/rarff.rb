# = rarff

# This is the top-level include file for rarff. See the README file for
# details.

################################################################################

# Custom scan that returns a boolean indicating whether the regex matched.
# TODO: Is there a way to avoid doing this?
class String
  def my_scan(re)
    hit = false
    scan(re) { |arr|
      yield arr if block_given?
      hit = true
    }
    hit
  end
end

################################################################################

module Enumerable
  # This map_with_index hack allows access to the index of each item as the map
  # iterates.
  # TODO: Is there a better way?
  def map_with_index
    # Ugly, but I need the yield to be the last statement in the map.
    i = -1 
    return map { |item|
      i += 1
      yield item, i
    }
  end
end

################################################################################

module Rarff

  COMMENT_MARKER = '%'
  RELATION_MARKER = '@RELATION'
  ATTRIBUTE_MARKER = '@ATTRIBUTE'
  DATA_MARKER = '@DATA'

  SPARSE_ARFF_BEGIN = '{'
  ESC_SPARSE_ARFF_BEGIN = '\\' + SPARSE_ARFF_BEGIN
  SPARSE_ARFF_END = '}'
  ESC_SPARSE_ARFF_END = '\\' + SPARSE_ARFF_END

  ATTRIBUTE_NUMERIC = 'NUMERIC'
  ATTRIBUTE_REAL = 'REAL'
  ATTRIBUTE_INTEGER = 'INTEGER'
  ATTRIBUTE_STRING = 'STRING'
  ATTRIBUTE_DATE = 'DATE'

  MISSING = '?'

  ################################################################################

  class Attribute
    attr_accessor :name, :type

    def initialize(name='', type='')
      @name = name
    
      @type_is_nominal = false
      @type = type

      check_nominal()
    end


    def type=(type)
      @type = type
      check_nominal()
    end


    # Convert string representation of nominal type to array, if necessary
    # TODO: This might falsely trigger on wacky date formats.
    def check_nominal
      if @type =~ /^\s*\{.*(\,.*)+\}\s*$/
        @type_is_nominal = true
        # Example format: "{nom1,nom2, nom3, nom4,nom5 } "
        # Split on '{'  ','  or  '}'
        @type = @type.gsub(/^\s*\{\s*/, '').gsub(/\s*\}\s*$/, '').split(/\s*\,\s*/)
      end
    end


    def add_nominal_value(str)
      if @type_is_nominal == false
        @type = Array.new
      end

      @type << str
    end


    def to_arff
      if @type_is_nominal == true
        ATTRIBUTE_MARKER + " #{@name} #{@type.join(',')}"
      else
        ATTRIBUTE_MARKER + " #{@name} #{@type}"
      end
    end


    def to_s
      to_arff
    end

  end



  class Relation
    attr_accessor :name, :attributes, :instances


    def initialize(name='')
      @name = name
      @attributes = Array.new
      @instances = Array.new
    end


    def parse(str)
      in_data_section = false

      # TODO: Doesn't handle commas in quoted attributes.
      str.split("\n").each { |line|
        next if line =~ /^\s*$/
        next if line =~ /^\s*#{COMMENT_MARKER}/
        next if line.my_scan(/^\s*#{RELATION_MARKER}\s*(.*)\s*$/i) { |name| @name = name }
        next if line.my_scan(/^\s*#{ATTRIBUTE_MARKER}\s*([^\s]*)\s+(.*)\s*$/i) { |name, type|
          @attributes.push(Attribute.new(name, type))
        }
        next if line.my_scan(/^\s*#{DATA_MARKER}/i) { in_data_section = true }
        next if in_data_section == false  ## Below is data section handling
        #      next if line.gsub(/^\s*(.*)\s*$/, "\\1").my_scan(/^\s*#{SPARSE_ARFF_BEGIN}(.*)#{SPARSE_ARFF_END}\s*$/) { |data|
        next if line.gsub(/^\s*(.*)\s*$/, "\\1").my_scan(/^#{ESC_SPARSE_ARFF_BEGIN}(.*)#{ESC_SPARSE_ARFF_END}$/) { |data|
          # Sparse ARFF
          # TODO: Factor duplication with non-sparse data below
          @instances << expand_sparse(data.first)
          create_attributes(true)
        }
        next if line.my_scan(/^\s*(.*)\s*$/) { |data|
          @instances << data.first.split(/,\s*/).map { |field|
            # Remove outer single quotes on strings, if any ('foo bar' --> foo bar)
            field.gsub(/^\s*\'(.*)\'\s*$/, "\\1")
          }
          create_attributes(true)
        }
      }
    end


    # Assign instances to the internal array
    # parse: choose to parse strings into numerics
    def instances=(instances, parse=false)
      @instances = instances
      create_attributes(parse)
    end


    
    def create_attributes(attr_parse=false)
      raise Exception, "Not enough data to create ARFF attributes" if @instances.nil? or 
        @instances.empty? or 
        @instances[0].empty?
      
      # Keep track of whether an attribute has been defined or not.
      # The only reason an attribute would not be defined in the first
      # row is if it has nil's in it. The geek inside screams for a binary
      # encoding like chmod but eh.
      attributes_defined = {}
      @instances.each_with_index { |row, i|
        row.each_with_index { |col, j|
          next if attributes_defined[j] or col.nil?
          
          attributes_defined[j] = true #whatever happens, we are going to define it
          if attr_parse
            if col =~ /^\-?\d+\.?\d*$/
              @attributes[j] = Attribute.new("Attr#{j}", ATTRIBUTE_NUMERIC)
            end
            next #parse next column - this one is finished
          end
          
          # No parsing - just take it how it is
          if col.kind_of?(Numeric)
            @attributes[j] = Attribute.new("Attr#{j}", ATTRIBUTE_NUMERIC)
          elsif col.kind_of?(String)
            @attributes[j] = Attribute.new("Attr#{j}", ATTRIBUTE_STRING)
          else
            raise Exception, "Could not parse attribute: #{col.inspect}"
          end
        }
      }
      
      # Make sure all attributes have a definition, because otherwise
      # needless errors are thrown
      @instances[0].each_index do |i|
        @attributes[i] ||= Attribute.new("Attr#{i}", ATTRIBUTE_NUMERIC)
      end
    end


    def expand_sparse(str)
      arr = Array.new(@attributes.size, 0)
      str.gsub(/^\s*\{(.*)\}\s*$/, "\\1").split(/\s*\,\s*/).map { |pr|
        pra = pr.split(/\s/)
        arr[pra[0].to_i] = pra[1]
      }
      arr
    end


    def to_arff(sparse=false)
      RELATION_MARKER + " #{@name}\n" +
        @attributes.map{ |attr| attr.to_arff }.join("\n") +
        "\n" +
        DATA_MARKER + "\n" +
        
        @instances.map { |inst|
        mapped = inst.map_with_index { |col, i|
          # First pass - quote strings with spaces, and dates
          # TODO: Doesn't handle cases in which strings already contain
          # quotes or are already quoted.
          unless col.nil?
            if @attributes[i].type =~ /^#{ATTRIBUTE_STRING}$/i
              if col =~ /\s+/
                col = "'" + col + "'"
              end
            elsif @attributes[i].type =~ /^#{ATTRIBUTE_DATE}/i  ## Hack comparison. Ugh.
              col = '"' + col + '"'
            end
          end
          
          # Do the final output
          if sparse
            if col.nil? or 
                (@attributes[i].type =~ /^#{ATTRIBUTE_NUMERIC}$/i and col == 0)
              nil
            else
              "#{i} #{col}"
            end
          else
            if col.nil?
              MISSING
            else
              col
            end
          end
        }
        
        if sparse
          mapped.reject{|col| col.nil?}.join(', ')
        else
          mapped.join(", ")
        end
      }.join("\n").gsub(/^/, sparse ? '{' : '').gsub(/$/, sparse ? '}' : '')
    end


    def to_s
      to_arff
    end

  end


end    # module Rarff

################################################################################

if $0 == __FILE__ then


  if ARGV[0]
    in_file = ARGV[0]
    contents = ''

    contents = File.open(in_file).read

    rel = Rarff::Relation.new
    rel.parse(contents)

  else
    exit
  end

  puts '='*80
  puts '='*80
  puts "ARFF:"
  puts rel


end

################################################################################


