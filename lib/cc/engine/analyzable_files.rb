SUFFIXES = %w[/ .coffee .coffee.md .litcoffee].freeze

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
          SUFFIXES.any? { |suffix| file.end_with?(suffix) }
        end
      end
    end
  end
end
