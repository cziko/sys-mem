module Sys 
  mem_file = "/proc/meminfo"
  $mem_hash = {}
  
  IO.foreach(mem_file){ |line|
    line.strip!
    next if line.empty?

    key, val = line.split(":")
    key.strip!
    key.gsub!(/\s+/,"_")
    key.downcase!
    val.strip! if val 

    # Converting strings to bytes
    match_data_val = /\d*/.match val
    value = match_data_val[0].to_i * 1024

    $mem_hash[key.to_sym] = value
  }   
   
  class Mem
    def self.data_hash
      $mem_hash
    end

    (class << self; self; end).class_eval do
      $mem_hash.each_pair do |key, value|
        define_method key.to_sym do
          value
        end 
      end 
    end 
  end
end
