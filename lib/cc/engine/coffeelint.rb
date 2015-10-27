require "json"
require "cc/engine/coffeelint_results"
require "cc/engine/analyzable_files"

module CC
  module Engine
    class Coffeelint
      def initialize(directory: , io: , engine_config: )
        @directory = directory
        @engine_config = engine_config
        @io = io
      end

      def run
        coffeelint_results.each do |path, errors|
          path = path.gsub(/\A\.\//, '')
          if include_path?(path)
            errors.each do |error|
              issue = {
                type: "Issue",
                description: error["message"],
                check_name: error["rule"],
                categories: [category(error['name'])],
                location: {
                  path: path,
                  lines: {
                    begin: error["lineNumber"],
                    end: error["lineNumber"]
                  }
                },
                remediation_points: remediation_points(error['name'])
              }
              @io.print("#{issue.to_json}\0")
            end
          end
        end
      end

      private

      def include_path?(path)
        analyzable_files.include?(path)
      end

      def analyzable_files
        @files ||= AnalyzableFiles.new(@directory, @engine_config).all
      end

      def coffeelint_results
        unless @coffeelint_results
          runner = CoffeelintResults.new(
            @directory, config: @engine_config['config']
          )
          @coffeelint_results = runner.results
        end
        @coffeelint_results
      end

      def remediation_points(error_name)
        ERROR_NAMES_TO_REMEDIATION_POINTS[error_name] || DEFAULT_REMEDIATION_POINTS
      end

      def category(error_name)
        ERROR_NAMES_TO_CATEGORY[error_name] || DEFAULT_ISSUE_CATEGORY
      end

      DEFAULT_ISSUE_CATEGORY = 'Style'
      DEFAULT_REMEDIATION_POINTS = 50_000

      ERROR_NAMES_TO_CATEGORY = {
        'cyclomatic_complexity' => 'Complexity',
        'coffeescript_error' => 'Bug Risk',
        'missing_fat_arrows' => 'Bug Risk',
        'no_empty_functions' => 'Bug Risk',
        'no_interpolation_in_single_quotes' => 'Bug Risk'
      }.freeze

      ERROR_NAMES_TO_REMEDIATION_POINTS = {
        'arrow_spacing' => 50_000,
        'braces_spacing' => 50_000,
        'camel_case_classes' => 250_000,
        'coffeescript_error' => 500_000,
        'colon_assignment_spacing' => 50_000,
        'cyclomatic_complexity' => 5_000_000,
        'duplicate_key' => 250_000,
        'empty_constructor_needs_params' => 50_000,
        'ensure_comprehensions' => 50_000,
        'eol_last' => 50_000,
        'indentation' => 250_000,
        'line_endings' => 250_000,
        'max_line_length' => 50_000,
        'missing_fat_arrows' => 250_000,
        'newlines_after_classes' => 50_000,
        'no_backticks' => 250_000,
        'no_debugger' => 50_000,
        'no_empty_functions' => 50_000,
        'no_empty_param_list' => 50_000,
        'no_implicit_braces' => 50_000,
        'no_implicit_parens' => 50_000,
        'no_interpolation_in_single_quotes' => 50_000,
        'no_plusplus' => 50_000,
        'no_stand_alone_at' => 50_000,
        'no_tabs' => 50_000,
        'no_this' => 50_000,
        'no_throwing_strings' => 50_000,
        'no_trailing_semicolons' => 50_000,
        'no_trailing_whitespace' => 50_000,
        'no_unnecessary_double_quotes' => 50_000,
        'no_unnecessary_fat_arrows' => 50_000,
        'non_empty_constructor_needs_parens' => 50_000,
        'prefer_english_operator' => 50_000,
        'space_operators' => 50_000,
        'spacing_after_comma' => 50_000,
        'transform_messes_up_line_numbers' => 50_000
      }.freeze
    end
  end
end
