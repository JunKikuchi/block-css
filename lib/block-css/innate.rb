module Innate
  module View
    register 'Innate::View::BlockCSS', :bcss

    module BlockCSS
      def self.call(action, string)
        string = transform_string(action, string) if action.view
        return string, 'text/css; charset=utf-8'
      end

      def self.transform_string(action, string)
        action.instance.instance_eval do
          args = action.params
          instance_eval(string)
        end
      end
    end
  end
end
