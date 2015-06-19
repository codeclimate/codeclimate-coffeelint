module CC
  module Engine
    class CoffeelintResults
      def initialize(directory, config: nil)
        @directory = directory
        @config = config
      end

      def results
        cmd = "coffeelint"
        cmd << " -f #{@config}" if @config
        cmd << " -q --reporter raw ."
        Dir.chdir(@directory) do
          JSON.parse(`#{cmd}`)
        end
      end
    end
  end
end
