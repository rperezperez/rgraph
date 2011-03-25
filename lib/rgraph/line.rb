module Rgraph
  class Line < Base
    def initialize args={}
      super
      @type = "Line"
      @values = []
      @chart_linewidth = 1
      @chart_labels = []
      @show_regression = false
      @chart_colors =[ 'rgb(234,157,138)', 'rgb(69,161,42)', '#9dc1e2', '#535557']      
      @chart_tickmarks = ['filledcircle', 'dot', 'tick', 'halftick']
           
    end
    
    def get_construct(id, canvas_id)
      if @show_regression
        values = []
        if self.get_values.first.class.to_s == "Array"
          values = self.get_values
        else
          values = [self.get_values]
        end
        for r in self.get_regression_values
          values << r 
        end
        return "var #{self.id(id)} = new RGraph.Line('#{canvas_id}', #{values.inspect.to_s});"
      else
        return "var #{self.id(id)} = new RGraph.Line('#{canvas_id}', #{self.get_values.inspect.to_s});"
      end
      
    end
    
  
  end
end