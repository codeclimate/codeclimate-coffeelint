require 'spec_helper'

module CC::Engine
  describe CoffeelintResults do
    describe "#results" do
      it "passes in a config file if specified" do
        results = CoffeelintResults.new(".", config: "mycoffeelint.json")
        expected_cmd = "coffeelint -f mycoffeelint.json -q --reporter raw ."
        expect(results).to \
          receive(:`).with(expected_cmd).and_return("{}")
        results.results
      end
    end
  end
end
