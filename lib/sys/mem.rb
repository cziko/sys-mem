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

    $mem_hash[key.to_sym] = val
  }   
   
  # TODO: 
  # * Mem methods should return integer not strings,
  #   default values should be in KB
  class Mem
    VERSION = '0.0.1'

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

    def self.total_memory
      $mem_hash[:memtotal]
    end
    
    def self.free_memory
      $mem_hash[:memfree]
    end
  end

end
