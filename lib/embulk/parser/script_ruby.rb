module Embulk
  module Parser

    class ScriptRuby < ParserPlugin
      Plugin.register_parser("script_ruby", self)

      def self.transaction(config, &control)
        # configuration code:
        task = {
          "script" => config.param("script", :string),
          "class" => config.param("class", :string),
          "columns" => config.param("columns", :array), 
        }

        c = 0
        columns = task['columns'].map do | e |
          col = Column.new(c, e['name'], e['type'].to_sym)
          c+=1
          col
        end

        yield(task, columns)
      end

      def init
        # initialization code:
        @script = task['script']
        @columns = task['columns']
        
        require @script
        @parser_class = Object.const_get(task['class']).new()
      end

      def run(file_input)
        while file = file_input.next_file
          @parser_class.parser(file) do |record|
            out_record = []
            @columns.each do | e |
              out_record << record[e['name']] if record.has_key?(e['name'])
            end
            page_builder.add(out_record) if  out_record.size > 0
          end
        end
        page_builder.finish
      end
    end

  end
end
