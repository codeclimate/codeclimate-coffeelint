require 'spec_helper'

module CC::Engine
  describe CoffeelintResults do
    describe "#results" do
      it "passes in a config file if specified" do
        results = CoffeelintResults.new(".", ["."], "mycoffeelint.json")
        expected_executable = File.expand_path("../../../node_modules/.bin/coffeelint", __dir__)
        expected_cmd = "#{expected_executable} -f mycoffeelint.json --reporter raw ."
        expect(results).to \
          receive(:`).with(expected_cmd).and_return("{}")
        results.results
      end
    end
  end
end
