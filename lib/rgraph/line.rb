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
      @interpolate_nil_values = true
    end

    def get_construct(id, canvas_id)

      values = []
      if self.get_values.first.class.to_s == "Array"
        values = self.get_values
      else
        values = [self.get_values]
      end

      i_values = []
      for v in values
        if @interpolate_nil_values
          i_values << Rgraph::Util.interpolate_nil_values(v)
        else
          i_values << v
        end
      end

      if @show_regression

        for r in self.get_regression_values
          i_values << r 
        end

      end

      return "var #{self.id(id)} = new RGraph.Line('#{canvas_id}', #{i_values.to_json});"


    end


  end
end