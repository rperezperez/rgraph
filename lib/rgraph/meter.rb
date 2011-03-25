module Rgraph
  class Meter < Base
    def initialize args={}
      super
      @type = "Meter"
      @min = 0
      @max = 100
      @value = 50
      @chart_gutter = 30
    end
    
    def get_construct(id, canvas_id)
      return "var #{self.id(id)} = new RGraph.Meter('#{canvas_id}', #{self.get_min}, #{self.get_max}, #{self.get_value});"
    end
    
    def green_interval(min, max, color_value = '#207A20')
      set_interval(min, max, 'green', color_value)
    end
    
    def yellow_interval(min, max, color_value = '#D0AC41')
      set_interval(min, max, 'yellow', color_value)
    end

    def red_interval(min, max, color_value = '#9E1E1E')
      set_interval(min, max, 'red', color_value)
    end

    private
    
    def set_interval(min, max, color = 'green', color_value = '#207A20')      
      self.instance_variable_set("@chart_#{color}_start", min)
      self.instance_variable_set("@chart_#{color}_end", max)
      self.instance_variable_set("@chart_#{color}_color", color_value)
    end 
  
  end
end