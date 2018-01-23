"use strict";

const fs = require("fs");
const path = require("path");
const coffeelint = require("coffeelint");
const configfinder = require('coffeelint/lib/configfinder');
const ignore = require("ignore");
const stripComments = require('strip-json-comments');
const CodeClimateFormatter = require("./codeclimate-formatter");

const DEFAULT_EXTENSIONS = [".coffee", ".coffee.md", ".litcoffee"];

function readFile(filename) {
  try {
    return fs.readFileSync(filename, "utf-8");
  } catch (ex) {
    return "";
  }
}

class Analyzer {
  constructor(directory, console, config) {
    this.directory = directory;
    this.console = console;
    this.config = config;

    // Load configuration.
    this.coffeelintConfig = this.loadConfig(config.config);
  }

  run() {
    let files = this.expandPaths(this.config.include_paths || ["./"]);
    if (fs.existsSync(path.join(this.directory, '.coffeelintignore'))) {
      files = ignore()
        .add(fs.readFileSync(path.join(this.directory, '.coffeelintignore')).toString())
        .filter(files);
    }

    this.processFiles(files);
  }


  // private =================================================================

  processFile(relativeFilePath) {
    let filePath = path.join(this.directory, relativeFilePath);
    let input = readFile(filePath);

    let fileConfig = this.coffeelintConfig || configfinder.getConfig(filePath);

    let result = coffeelint.lint(input, fileConfig)

    CodeClimateFormatter.report(result, relativeFilePath, this.console);
  }


  processFiles(files) {
    for (let file of files) {
      this.processFile(file);
    }
  }


  expandPaths(paths) {
    let files = [];

    for (let path of paths) {
      let new_files = this.getFiles(path);
      files = files.concat(new_files);
    }

    return files;
  }

  getFiles(pathname) {
    var files = [];
    let full_pathname = path.normalize(path.join(this.directory, pathname));
    let stat;
    let base_name = path.basename(pathname);

    try {
      stat = fs.statSync(full_pathname);
    } catch (ex) {
      return [];
    }

    if (stat.isFile() && this.extensionsRegExp.test(full_pathname)) {
      return [pathname];
    } else if (stat.isDirectory()) {
        for (let file of fs.readdirSync(full_pathname)) {
          let new_path = path.join(full_pathname, file);
          files = files.concat(this.getFiles(path.relative(this.directory, new_path)));
        };
    }

    return files;
  }

  get extensionsRegExp() {
    return RegExp(
      (this.config.extensions || DEFAULT_EXTENSIONS).
        map(e => e.replace('.', '\\.')).
        join("|") +
        "$"
    );
  }

  loadConfig(configPath) {
    let config = null;
    if (configPath) {
      let text = readFile(fs.realpathSync(path.join(this.directory, configPath)));
      config = JSON.parse(stripComments(text));

      // If -f was specifying a package.json, extract the config
      if (config.coffeelintConfig) {
        config = config.coffeelintConfig;
      }
    }
    return config;
  }
}

module.exports = class {
  constructor(directory, console, config) {
    this.analyzer = new Analyzer(directory, console, config);
  }

  run() {
    this.analyzer.run();
  }
};
