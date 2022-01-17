# frozen_string_literal: true

require 'shellwords'

module CC
  module Engine
    class CoffeelintResults
      DEFAULT_CONFIG_PATH = "/code/coffeelint.json"

      def initialize(directory, files, config)
        @directory = directory
        @files = files
        @config = config
      end

      def results
        return [] if files.empty?

        escaped_files = Shellwords.join(files)
        cmd = File.expand_path("../../../node_modules/.bin/coffeelint", __dir__)
        cmd << " -f #{config_path}" if config_path
        cmd << " --reporter raw #{escaped_files}"
        Dir.chdir(directory) do
          JSON.parse(`#{cmd}`)
        end
      end

      private

      attr_reader :directory, :files, :config

      def config_path
        if config
          config
        elsif File.exist? DEFAULT_CONFIG_PATH
          DEFAULT_CONFIG_PATH
        end
      end
    end
  end
end
