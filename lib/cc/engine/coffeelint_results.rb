module CC
  module Engine
    class CoffeelintResults
      def initialize(config)
        @config = config
      end

      def results
        cmd = "coffeelint"
        cmd << " -f #{@config}" if @config
        cmd << " -q --reporter raw ."
        JSON.parse(`#{cmd}`)
      end
    end
  end
end
