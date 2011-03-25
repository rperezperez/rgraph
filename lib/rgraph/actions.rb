require 'fastercsv'
require 'iconv'

module Rgraph
  module Actions
    
    # Define an action to return a csv file for a controller.
    def rgraph_get_csv
      filename = params[:filename] || 'salida.csv'
      data = params[:data]

      fcsv_options = {
        :row_sep => "\n",
        :col_sep => ";",
        :force_quotes => false
      }

      data = eval(YAML.load(data))

      if request.env['HTTP_USER_AGENT'] =~ /msie/i
        headers['Pragma'] = 'public'
        headers["Content-type"] = "text/plain" 
        headers['Cache-Control'] = 'no-cache, must-revalidate, post-check=0, pre-check=0'
        headers['Content-Disposition'] = "attachment; filename=\"#{filename}\"" 
        headers['Expires'] = "0" 
      else
        headers["Content-Type"] ||= 'text/csv'
        headers["Content-Disposition"] = "attachment; filename=\"#{filename}\"" 
      end

      csv_string = FasterCSV.generate(fcsv_options) do |csv| 
        data.each do |e|
          csv << e
        end
      end

      obj_iconv = Iconv.new('iso-8859-1','utf-8')
      send_data obj_iconv.iconv(csv_string), :type => "text/plain",:filename=>filename, :disposition => 'attachment'      

    end
  end
end