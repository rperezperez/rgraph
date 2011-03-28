module Rgraph
  class Base

    def initialize(args={})

      #defaults options for chart
      @chart_annotatable = true
      @chart_resizable = true

      @chart_text_color = "#7b8992"
      @chart_text_size = 8

      @chart_title_color = "#7b8992"
      @chart_title_xaxis_pos = 0.2
      @chart_title_yaxis_pos = 0.2
      @chart_gutter = 45

      @chart_key_position = 'gutter'
      @chart_key_halign = 'left'

      @chart_background_barcolor1 = 'rgba(235, 239, 243, 0.7)'
      @chart_background_barcolor2 = 'rgba(235, 239, 243, 0.7)'
      @chart_background_grid = false
      @chart_axis_color = '#d4e4f2' 

      args.each do |k,v|
        self.instance_variable_set("@#{k}", v)
      end
      yield self if block_given?  # magic pen pattern
    end

    def get_csv
      salida = []
      if @values != nil
        values = @values
        values = [values] if values.first.class.to_s != "Array"        
        salida << ['', @chart_labels].flatten
        i = 0
        for v in values
          salida << [(@chart_key[i] if i < @chart_key.length) || '', v].flatten
          i += 1
        end
      end
      salida.inspect.to_s
    end

    # Return a specific id for a chart.
    def id(suffix = '')
      return "r_#{suffix}"
    end

    # Set the title
    def set_title(title)
      @chart_title = title
    end

    # Set the legend for X/Y axis.
    def set_axis(xaxis, yaxis)
      @chart_title_xaxis = xaxis
      @chart_title_yaxis = yaxis
    end

    # Functions that generate the different tooltips with the values of charts
    def generate_tooltips
      @chart_tooltips = []
      values = get_values
      values = [values] if values.first.class.to_s != "Array"

      for v in values
        @chart_tooltips << v.map{|x| x.to_s}
      end

      @chart_tooltips.flatten!
      @chart_tooltips_effect = 'expand'

    end

    # Return the javascripts code to config the chart
    def config(id, canvas_id, draw = false)
      output = []

      output << "var config_#{self.id(id)} = #{self.get_charts};"
      output << "RGraph.SetConfig(#{self.id(id)}, config_#{self.id(id)});" 
      output << "#{self.id(id)}.Draw();" if draw

      return output.join(13.chr)

    end

    # Generate the regression line for each values array.
    def calculate_regression
      #check if values is an array of elements or an array of arrays
      return false if self.instance_values.has_key?("values") == false

      @regression = Array.new
      @regression_values = Array.new

      values = @values
      values = [@values] if @values.first.class.to_s != "Array"

      for v in values
        #Calculamos la linea de regresion para cada vector
        l_r = Rgraph::Util.regression_simple(v)          
        @regression_values << l_r[1]
        @regression << l_r[0]        
      end

    end
  
    # Get the different configurations parameters
    def get_charts
      variables = self.instance_values
      output = Hash.new
      for v in variables
        if v[0].index("chart_") == 0
          output[v[0].gsub("_", ".")] = v[1]
        end
      end

      return output.to_json
    end

    alias_method :to_s, :get_charts

    # This method help to set and get the dinamical variables.
    def method_missing(method_name, *args, &blk)
      case method_name.to_s
      when /(.*)=/   # i.e., if it is something x_legend=
        # if the user wants to set an instance variable then let them
        # the other args (args[0]) are ignored since it is a set method
        self.instance_variable_set("@#{$1}", args[0])
      when /^set_(.*)/
        # backwards compatible ... the user can still use the same set_y_legend methods if they want
        self.instance_variable_set("@#{$1}", args[0])
      when /^get_(.*)/
        # backwards compatible ... the user can still use the same set_y_legend methods if they want
        self.instance_variable_get("@#{$1}")        
      else
        # if the method/attribute is missing and it is not a set method then hmmmm better let the user know
        super
      end
    end

  end
end
