module Sys 
  # Should use instance variables insead of global ones
  # Not really sure what was the reason for using $.
  $mem_file = "/proc/meminfo"
  $mem_hash = {}
  
  IO.foreach($mem_file){ |line|
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
   
  class MEM
    def self.data_hash
      self.reload_file
      $mem_hash
    end

    # TODO:
    # * Methods should return bytes, kilobytes, mebagytes
    #   depending on params
    (class << self; self; end).class_eval do
      $mem_hash.each_pair do |key, value|
        define_method key.to_sym do
          self.reload_file
          return $mem_hash[key.to_sym]
        end 
      end 
    end 

    #def self.memtotal
    #end
    #def self.memfree
    #end

    def self.reload_file
      lines = IO.readlines($mem_file)
      lines.each{ |line|
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
    end

  end
end
