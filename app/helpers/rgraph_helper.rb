require 'htmlentities'

module RgraphHelper
  
def rgraph_includes(libraries)
  includes = ''
  includes << stylesheet_link_tag('rgraph/rgraph')
  
  includes << javascript_include_tag("prototype.js")  
  includes << javascript_include_tag("rgraph/RGraph.common.core.js")
  includes << javascript_include_tag("rgraph/RGraph.common.context.js")
  includes << javascript_include_tag("rgraph/RGraph.common.annotate.js")
  includes << javascript_include_tag("rgraph/RGraph.common.tooltips.js")      
  includes << javascript_include_tag("rgraph/RGraph.common.resizing.js")      
  
  for l in libraries
    includes << javascript_include_tag('rgraph/Rgraph.'+l.to_s)    
  end
  
  includes
end

def rgraph_get_csv_file(csv, text = 'CSV', class_name='verdeClaro')
  
  id = Rgraph::Util.generate_id
  
  <<-HTML
     
  <form id="rgraph_csv_#{id}" method="post" action="/#{controller_name}/rgraph_get_csv">
		#{hidden_field_tag(:data, YAML::dump(csv)) }
		#{hidden_field_tag request_forgery_protection_token.to_s, form_authenticity_token}		
		<a href="#" class="#{class_name}" onclick="$('rgraph_csv_#{id}').submit(); return false;">#{text}</a>
	</form>
	
	HTML
	  
end


def rgraph_get_csv_file2(csv)
  includes = ''
    coder = HTMLEntities.new
    data = CGI.escape(URI.escape(coder.encode(csv, :named)))

    
#  includes << "<a href='#' onclick='rgraph_csv(#{csv});'>hola</a>"
#  includes << "<script type=\"text/javascript\">"      
  includes << "<a href='#' onclick=\""+remote_function(:url => {:action => 'rgraph_get_csv'}, :with => 'data='+data)+"\">hola</a>"
  #includes << 

  includes
  
end

#{}"  function rgraph_csv(chart){
#{}      
#{}      alert(chart);
#{}      return true;
#{}   }
#{}</script>
#{}"

#var myWindow=window.open("","new","")
#myWindow.document.open("application/excel")
#myWindow.document.write("1,2,3")
#myWindow.close()


end