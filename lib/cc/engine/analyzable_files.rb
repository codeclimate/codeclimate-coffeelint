module CC
  module Engine
    class AnalyzableFiles
      def initialize(directory, config)
        @directory = directory
        @config = config
      end

      def all
        @results ||= if @config["include_paths"]
          build_files_with_inclusions(@config["include_paths"])
        else
          build_files_with_exclusions(@config["exclude_paths"] || [])
        end
      end

      private

      def fetch_files(paths)
        paths.map do |path|
          if path =~ %r{/$}
            Dir.glob("#{path}**/*.coffee")
          else
            path if path =~ /\.coffee$/
          end
        end.flatten.compact
      end

      def build_files_with_inclusions(inclusions)
        if inclusions == ["./"]
          Dir.glob("**/*.coffee")
        else
          fetch_files(inclusions)
        end
      end

      def build_files_with_exclusions(exclusions)
        files = Dir.glob("#{@directory}/**/*.coffee")
        excluded_files = fetch_files(exclusions)
        files.reject { |f| exclusions.include?(f) }
      end
    end
  end
end
