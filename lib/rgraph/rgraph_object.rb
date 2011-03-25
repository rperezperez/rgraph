module Rgraph
  module Controller

    def self.included(base) # :nodoc:
      base.send :extend, ClassMethods
    end

    # Get the code neccesary to show a Rgraph chart. 
    # Return three parameters: id of objects created, html code and array data for csv propouse.
    def rgraph_object_and_div_and_csv(width, height, chart, id = nil)

      id = Rgraph::Util.generate_id if id == nil

      html = get_html(width, height,chart, id)
      return [id, html, chart.get_csv]
    end

    # Identical functionality that rgraph_object_and_div. Only returns id and html code.
    def rgraph_object_and_div(width, height, chart, id = nil)

      id = Rgraph::Util.generate_id if id == nil

      html = get_html(width, height,chart, id)
      return [id, html]
    end

    # Get the javascript code to show a Rgraph chart. It is useful if you want to control different chart in a same canvas.
    def rgraph_javascript(chart, canvas_id)
      id = Rgraph::Util.generate_id if id == nil

      javascript = get_javascript(chart, id, canvas_id)

      return [id, javascript]

    end

    # Internal functions
    def get_javascript(chart, id, canvas_id)
      <<-HTML

      <script type="text/javascript">

      #{chart.get_construct(id, 'c_r_'+canvas_id)}
      var config = #{chart.get_charts()};
      RGraph.SetConfig(r_#{id}, config); 

      r_#{id}.Draw();

      </script>

      HTML

    end

    def get_html(width, height, chart, id)

      <<-HTML
      <div id="d_r_#{id}">        

        <canvas id="c_r_#{id}" class="rgraph" width="#{width}px" height="#{height}px"><div class="canvasfallback">[No canvas support]</div></canvas> 

      </div>

      <script type="text/javascript">

      #{chart.get_construct(id, 'c_r_'+id)}
      var config = #{chart.get_charts()};
      RGraph.SetConfig(r_#{id}, config); 

      r_#{id}.Draw();

      </script>

      HTML

    end

    module ClassMethods
      def rgraph_includes
        self.send :include, Rgraph::Actions
      end   
    end     

  end

end
