"use strict";

const DEFAULT_IDENTIFIER = "parse-error";

const DEFAULT_ISSUE_CATEGORY = 'Style';
const DEFAULT_REMEDIATION_POINTS = 50000;

const ERROR_NAMES_TO_CATEGORY = {
  cyclomatic_complexity: 'Complexity',
  coffeescript_error: 'Bug Risk',
  missing_fat_arrows: 'Bug Risk',
  no_empty_functions: 'Bug Risk',
  no_interpolation_in_single_quotes: 'Bug Risk'
};

const ERROR_NAMES_TO_REMEDIATION_POINTS = {
        arrow_spacing: 50000,
        braces_spacing: 50000,
        camel_case_classes: 250000,
        coffeescript_error: 500000,
        colon_assignment_spacing: 50000,
        cyclomatic_complexity: 5000000,
        duplicate_key: 250000,
        empty_constructor_needs_params: 50000,
        ensure_comprehensions: 50000,
        eol_last: 50000,
        indentation: 250000,
        line_endings: 250000,
        max_line_length: 50000,
        missing_fat_arrows: 250000,
        newlines_after_classes: 50000,
        no_backticks: 250000,
        no_debugger: 50000,
        no_empty_functions: 50000,
        no_empty_param_list: 50000,
        no_implicit_braces: 50000,
        no_implicit_parens: 50000,
        no_interpolation_in_single_quotes: 50000,
        no_plusplus: 50000,
        no_stand_alone_at: 50000,
        no_tabs: 50000,
        no_this: 50000,
        no_throwing_strings: 50000,
        no_trailing_semicolons: 50000,
        no_trailing_whitespace: 50000,
        no_unnecessary_double_quotes: 50000,
        no_unnecessary_fat_arrows: 50000,
        non_empty_constructor_needs_parens: 50000,
        prefer_english_operator: 50000,
        space_operators: 50000,
        spacing_after_comma: 50000,
        transform_messes_up_line_numbers: 50000
};

function remediationPoints(error_name) {
  return ERROR_NAMES_TO_REMEDIATION_POINTS[error_name] || DEFAULT_REMEDIATION_POINTS;
}

function category(error_name) {
  return ERROR_NAMES_TO_CATEGORY[error_name] || DEFAULT_ISSUE_CATEGORY;
}


function reportJSON(filename, error) {
  let issue = {
    type: "issue",
    description: error.message,
    check_name: error.rule,
    categories: [category(error.rule)],
    location: {
      path: filename,
      lines: {
        begin: error.lineNumber,
        end: error.lineNumberEnd || error.lineNumber
      }
    },
    remediation_points: remediationPoints(error.rule)
  };
  if ("description" in error) {
    issue["content"] = { body: error.description }
  }

  return JSON.stringify(issue);
}

module.exports = {
  report: function(results, filename, console = console) {
    let reports = results.messages;
    let output = [];

    for (let issue of results) {
      console.log(reportJSON(filename, issue) + "\x00");
    }
  }
};
