#!/usr/bin/env ruby
# encoding: UTF-8


Encoding.default_internal = 'UTF-8'
Encoding.default_external = 'UTF-8'


require 'json'
require 'stringio'

if ARGV.count != 1
  $stderr.puts "error. usage: #{__FILE__} some-json-file"
  exit -1
end

def read_json(filename)
  $stderr.puts "info. reading JSON: '#{filename}'"
  json = JSON.parse(File.read(filename))

  if !json['files']
    $stderr.puts "error. JSON needs key 'files'"
    exit -2
  end

  if !(json['files'].is_a? Array)
    $stderr.puts "error. 'files' is no array"
    exit -3
  end

  dir = File.dirname(filename)

  if json['title'] && !json['title'].empty?
    $result.puts "# #{json['title']}"
    $result.puts
  end

  json['files'].each_with_index do |file, i|
    if !(file.is_a? String)
      $stderr.puts "error. bad object found in 'files' at element #{i}"
      exit -4
    end

    files = Dir.glob("#{dir}/#{file}").sort

    if files.length == 0
      $stderr.puts "error. file(s) not found: '#{"#{dir}/#{file}"}'"
      exit -5
    end

    files.each_with_index do |filename, j|
      if filename =~ /json$/i
        read_json(filename)
      elsif filename =~ /md$/i
				read_md(filename)
			elsif filename =~ /txt$/i
	        read_txt(filename)
      else
        $stderr.puts "error. filename '#{filename}' is no json or text in md or txt format"
        exit -6
      end

    end

  end

end

def read_md(filename)
  $stderr.puts "info. reading MD:   '#{filename}'"
  $result.print File.read("#{filename}")

end

def read_txt(filename)
  $stderr.puts "info. reading txt:   '#{filename}'"
  $result.print File.read("#{filename}")

end

def roman(num)
  roman_arr = {
    1000 => "M",
    900 => "CM",
    500 => "D",
    400 => "CD",
    100 => "C",
    90 => "XC",
    50 => "L",
    40 => "XL",
    10 => "X",
    9 => "IX",
    5 => "V",
    4 => "IV",
    1 => "I"
  } 

  roman_arr.reduce("") do |res, (arab, roman)|
    whole_part, num = num.divmod(arab)
    res << roman * whole_part
  end
end

$result = StringIO.new
read_json(ARGV[0])
layer1 = 1
layer2 = 1

$result.string.each_line do |line|

  if line =~ /^### /
    line.sub!(/^### /, " #{layer2}. ")
    layer2 += 1
  elsif line =~ /^## /
    line.sub!(/^## /, " #{roman(layer1)}. ")
    layer1 += 1
    layer2 = 1
  end

  puts line
end
