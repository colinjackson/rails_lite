require_relative '../phase2/controller_base'
require 'active_support/core_ext'
require 'active_support/inflector'
require 'erb'

module Phase3
  class ControllerBase < Phase2::ControllerBase
    # use ERB and binding to evaluate templates
    # pass the rendered html to render_content
    def render(template_name)
      views_filename = self.class.to_s.underscore
      template_filename = "views/#{views_filename}/#{template_name}.html.erb"
      template_data = File.read(template_filename)
      content = ERB.new(template_data).result(binding)
      
      render_content(content, 'text/html')
    end
  end
end
