module Rgraph
  
  class Area < Line
    
    def initialize args={}
      super
      @type = "Area"
      @chart_filled = true  
      @chart_colors =[ 'rgb(234,157,138)', 'rgb(69,161,42)']
      @chart_fillstyle =[ 'rgba(241,171,153,0.5)', 'rgba(142,204,124,0.5)']
            @chart_linewidth = 2
                @chart_background_barcolor1 = 'rgba(235,239,243,0.3)'
          @chart_background_barcolor2 = 'rgba(235,239,243,0.3)'

    end
    
    # Paritucal function to make possible a special Line Chart. 
    # Draw different chart for each values vector in a same vector. 
    def get_construct(id, canvas_id)
      salida = []
      
      self.chart_ymax = Rgraph::Util.get_max([@values, @regression_values].flatten) + 2
      self.chart_ymin = 0
            
      
      if @show_regression
        
        
        l_r = Line.new
        l_r.values = Rgraph::Util.drop_negative(@regression_values)        
        l_r.chart_noaxes = true
        l_r.chart_ylabels = false
        l_r.chart_background_grid = false
        l_r.chart_ymax = self.get_chart_ymax
        l_r.chart_ymin = self.get_chart_ymin
        l_r.chart_xaxispos = self.get_chart_xaxispos
        l_r.chart_colors = ['#ea8267','#a2cd9b','black']
        l_r.chart_tickmarks = 'dot'
        l_r.chart_gutter = self.get_chart_gutter
        
        salida << l_r.get_construct(id+"_r", canvas_id)
        salida << l_r.config(id+"_r", canvas_id, true)
        if @interpolate_nil_values
          i_values = Rgraph::Util.interpolate_nil_values(self.get_values)
        else
          i_values = self.get_values
        end
        
        salida << "var #{self.id(id)} = new RGraph.Line('#{canvas_id}', #{i_values.to_json});"
        
      end
      
      values = self.get_values
      values = [self.get_values] if self.get_values.first.class.to_s != "Array"
      
      i= 0
      colors = self.get_chart_fillstyle
      lines = self.get_chart_colors
      for v in values
        if @interpolate_nil_values
          i_v = Rgraph::Util.interpolate_nil_values(v)
        else
          i_v = v
        end

        if i == 0
          salida << "var #{self.id(id)} = new RGraph.Line('#{canvas_id}', #{i_v.to_json});"
        else
          salida << "var #{self.id(id)}_#{i} = new RGraph.Line('#{canvas_id}', #{i_v.to_json});"
          self.chart_fillstyle = colors[i]
          self.chart_colors = [lines[i]]
          salida << self.config(id+"_"+i.to_s, canvas_id, true)
        end    
        i += 1
      end
      
      self.chart_fillstyle = colors
      self.chart_colors = lines
      
      return salida.join(13.chr)
      
    end
    
    
  end
  
end