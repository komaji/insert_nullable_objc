#!/usr/bin/ruby

DIRECTORY_PATTERN = './path/to/dir/**/*'
TARGET_FILE_REGEXP = /.*\.(h|m)$/
NULLABILITY = [
  'nullable',
  'nonnull',
  '_Nullable',
  '_Nonnull',
]

def check_property(line)
  line =~ /^@property/
end

def check_typedef(line)
  line =~ /^typedef/
end

def check_method(line)
  line =~ /^(\+|-)\s?/
end

def check_nullability(line)
  line !~ Regexp.union(NULLABILITY)
end

def insert_nullable_type(line)
  line.split(',').map { |str|
    next str unless check_nullability(str)
    
    nullable = '* _Nullable '
    nullable.lstrip! if str =~ /\s\*/
    str.gsub('*', nullable)
  }.join(',')
end

def insert_nullable_block(line)
  result = ''
  dup = line.dup
  temp = dup.slice!(/.*\^[\s\_\w]*\)/)
  result << (check_nullability(temp) ? temp.sub('^', '^ _Nullable') : temp)
  result << insert_nullable_type(dup)
  result
end

def split_method(line)
  results = []
  temp = ''
  parentheses_count = 0

  line.chars do |c|
    if c == '('
      if parentheses_count.zero?
        results << temp
        temp = ''
      end
      
      temp << c
      parentheses_count += 1
    elsif c == ')'
      parentheses_count -= 1
      temp << c
      
      if parentheses_count.zero?
        results << temp
        temp = ''
      end
    else
      temp << c
    end
  end

  results << temp
end

def insert_nullable_method(line)
  split_method(line).map { |str|
    next str unless str.include?('(')
    
    if str.include?('^')
      insert_nullable_block(str)
    else
      insert_nullable_type(str)
    end
  }.join
end

def exec
  Dir.glob(DIRECTORY_PATTERN).select{ |f| f =~ TARGET_FILE_REGEXP }.each do |f|
    puts "-------------------------------------------------------"
    puts f
    puts "-------------------------------------------------------"
    
    result = ''
    method_semicolon_exist = true
    
    File.read(f).each_line do |l|
      temp = if check_property(l) || check_typedef(l)
               insert_nullable_type(l)
             elsif check_method(l) || !method_semicolon_exist
               method_semicolon_exist = l.include?(';')
               insert_nullable_method(l)
             else
               l
             end

      puts "-#{l}+#{temp}\n" unless temp == l

      result << temp
    end
    
    File.write(f, result)
  end

  puts "\nFinish!!!"
end

exec
