require 'spec_helper'

module CC::Engine
  describe Coffeelint do
    describe "#run" do
      it "should process results" do
        results = {
          './cool.coffee' => [
            {
              "name" => "indentation",
              "value" => 2,
              "level" => "error",
              "message" => "Line contains inconsistent indentation",
              "description" => "",
              "context" => "Expected 2 got 4",
              "lineNumber" => 2,
              "line" => "    if num is 1",
              "rule" => "indentation"
            }
          ]
        }
        allow_any_instance_of(CoffeelintResults).to receive(:results).
          and_return(results)
        mock_io = double

        expect(mock_io).to receive(:print).
          with("{\"type\":\"Issue\",\"description\":\"Line contains inconsistent indentation\",\"check_name\":\"indentation\",\"categories\":[\"Style\"],\"location\":{\"path\":\"cool.coffee\",\"lines\":{\"begin\":2,\"end\":2}},\"remediation_points\":250000}\u0000")

        Coffeelint.new(directory: '.', io: mock_io, engine_config: {}).run
      end

      it "doesn't return excluded files" do
        results = {
          './cool.coffee' => [
            {
              "name" => "indentation",
              "value" => 2,
              "level" => "error",
              "message" => "Line contains inconsistent indentation",
              "description" => "",
              "context" => "Expected 2 got 4",
              "lineNumber" => 2,
              "line" => "    if num is 1",
              "rule" => "indentation"
            }
          ]
        }
        allow_any_instance_of(CoffeelintResults).to receive(:results).
          and_return(results)
        mock_io = double
        expect(mock_io).to receive(:print).never
        Coffeelint.new(
          directory: '.',
          io: mock_io,
          engine_config: {"exclude_paths" => ["cool.coffee"]}
        ).run
      end
    end
  end
end
