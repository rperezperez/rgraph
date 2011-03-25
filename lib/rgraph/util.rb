require 'digest/sha1'
require 'statsample'

module Rgraph
  class Util < Base
    
    def self.generate_id
      @special_hash = Base64.encode64(Digest::SHA1.digest("#{rand(1<<64)}/#{Time.now.to_f}/#{Process.pid}/#{@ofc_url}"))[0..7]
      @special_hash = @special_hash.gsub(/[^a-zA-Z0-9]/,rand(10).to_s)     
      return "rgraph_#{@special_hash}"
    end
    
    def self.regression_simple(y)
      a = y.to_scale
      b = (1..y.length).to_a.to_scale
      ds={"a"=>a,"b"=>b}.to_dataset
      l_r = Statsample::Regression::Simple.new_from_dataset(ds,"b", "a")
      values = b.map{|x| (x*l_r.b + l_r.a)}
      return [l_r, values]
    end
    
    def self.drop_negative(values)
       values = [values] if values.first.class.to_s != "Array"
       
       for v in values
         v.collect!{|x| (x = 0 if x < 0) || x}
       end
       
       return values
    end
    
    def self.get_max(values)
      return nil if values == nil
      
      max = values.first
      values.map{|x| max = x if max < x}
      
      return max
    end
        
  end
end
