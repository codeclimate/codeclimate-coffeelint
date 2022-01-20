# frozen_string_literal: true

module CC
  module Engine
    class AnalyzableFiles
      SUFFIXES = %w[/ .coffee .coffee.md .litcoffee].freeze

      def initialize(config)
        @config = config
      end

      def all
        @all ||= if (include_paths = @config["include_paths"])
                   filter_files(include_paths)
                 else
                   fail <<~EOS
                     error: `include_paths' not provided\n
                     This is probably due to an old version of the codeclimate CLI being used.
                     Please try updating.
                   EOS
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
