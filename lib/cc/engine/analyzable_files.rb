module CC
  module Engine
    class AnalyzableFiles
      def initialize(config)
        @config = config
      end

      def all
        @results ||= if (include_paths = @config["include_paths"])
          filter_files(include_paths)
        else
          fail "error: `include_paths' not provided\nThis is probably due to an old version of the codeclimate CLI being used. Please try updating."
        end
      end

      private

      def filter_files(files)
        files.select do |file|
          file.end_with?("/") || file.end_with?(".coffee") || file.end_with?(".coffee.md") || file.end_with?(".litcoffee")
        end
      end
    end
  end
end
