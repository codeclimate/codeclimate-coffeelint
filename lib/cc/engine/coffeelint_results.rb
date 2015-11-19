require 'shellwords'

module CC
  module Engine
    class CoffeelintResults
      def initialize(directory, files, config)
        @directory = directory
        @config = config
        @files = files
      end

      def results
        escaped_files = Shellwords.join(@files)
        cmd = "coffeelint"
        cmd << " -f #{@config}" if @config && @config != ""
        cmd << " -q --reporter raw #{escaped_files}"
        Dir.chdir(@directory) do
          JSON.parse(`#{cmd}`)
        end
      end
    end
  end
end
