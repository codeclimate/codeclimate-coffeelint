"use strict";
const chai = require("chai");
const Engine = require("../lib/coffeelint");
const path = require("path");
const temp = require('temp').track();
const mkdirp = require('mkdirp').sync;
const expect = require("chai").expect;
const fs = require("fs");
const sinon = require("sinon");
const sinonChai = require("sinon-chai");
chai.use(sinonChai);

const LONG_LINE = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa" +
  "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa";

function makeFile(root, filename, contents) {
  let dirname = path.dirname(path.join(root, filename));
  if (!fs.existsSync(dirname)) {
    mkdirp(dirname);
  }
  fs.writeFileSync(path.join(root, filename), contents || "}");
}

class FakeConsole {
  constructor() {
    this.logs = [];
    this.warns = [];
  }

  get output() {
    return this.logs.join("\n");
  }


  log(str) {
    this.logs.push(str);
  }

  warn(str) {
    console.warn(str);
    this.warns.push(str);
  }
}


describe("CoffeeLint Engine", function() {
  beforeEach(function(){
    this.code_dir = temp.mkdirSync("code");
    this.console = new FakeConsole();
  });

  it("prints out results when include paths is ./", function() {
    makeFile(this.code_dir, "foo.coffee", LONG_LINE)
    makeFile(this.code_dir, "bar.coffee", LONG_LINE)
    let log = sinon.spy(this.console, "log");

    new Engine(
      this.code_dir,
      this.console,
      { include_paths: ["./"] }
    ).run();

    expect(log).to.have.been.calledTwice;
  });

  it("prints out results for specific files and folders", function() {
    makeFile(this.code_dir, "foo.coffee", LONG_LINE);
    makeFile(this.code_dir, "wat.coffee", LONG_LINE);
    makeFile(this.code_dir, "bar.coffee", LONG_LINE);
    makeFile(this.code_dir, "baz/other.coffee", LONG_LINE);
    let log = sinon.spy(this.console, "log");

    new Engine(
      this.code_dir,
      this.console,
      { include_paths: ["baz/", "foo.coffee", "wat.coffee"] }
    ).run();

    expect(log).to.have.been.calledThrice;
  });

  it("prints out no results if there are no analyzable files", function() {
    makeFile(this.code_dir, "foo.rb", LONG_LINE)
    let log = sinon.spy(this.console, "log");

    new Engine(
      this.code_dir,
      this.console,
      { include_paths: ["foo.rb"] }
    ).run();

    expect(log).to.not.have.been.called;
  });

  it("prints out the proper message", function() {
    makeFile(this.code_dir, "foo.coffee", LONG_LINE);

    new Engine(
      this.code_dir,
      this.console,
      { include_paths: ["foo.coffee"] }
    ).run();

    expect(this.console.output).to.include('{"type":"issue","description":"Line exceeds maximum allowed length","check_name":"max_line_length","categories":["Style"],"location":{"path":"foo.coffee","lines":{"begin":1,"end":1}},"remediation_points":50000,"content":{"body":"This rule imposes a maximum line length on your code. <a\\nhref=\\"http://www.python.org/dev/peps/pep-0008/\\">Python\'s style\\nguide</a> does a good job explaining why you might want to limit the\\nlength of your lines, though this is a matter of taste.\\n\\nLines can be no longer than eighty characters by default."}}\x00')
  });

  it("includes warning-level issues", function() {
    makeFile(this.code_dir, "foo.coffee", "debugger");

    new Engine(
      this.code_dir,
      this.console,
      { include_paths: ["foo.coffee"] }
    ).run();

    expect(this.console.output).to.include("{\"type\":\"issue\",\"description\":\"Found debugging code\",\"check_name\":\"no_debugger\",\"categories\":[\"Style\"],\"location\":{\"path\":\"foo.coffee\",\"lines\":{\"begin\":1,\"end\":1}},\"remediation_points\":50000,\"content\":{\"body\":\"This rule detects `debugger` and optionally `console` calls\\nThis rule is `warn` by default.\"}}\x00")
  });

  it("works with files that have spaces", function() {
    makeFile(this.code_dir, "foo bar.coffee", LONG_LINE);
    let log = sinon.spy(this.console, "log");

    new Engine(
      this.code_dir,
      this.console,
      { include_paths: ["./"] }
    ).run();

    expect(log).to.have.been.calledOnce
  });

  it("uses custom config when specified", function() {
    makeFile(this.code_dir, "foo bar.coffee", LONG_LINE);
    makeFile(this.code_dir, "my-coffeelint-config.json", '{"max_line_length":{"level":"ignore"}}');
    let log = sinon.spy(this.console, "log");

    new Engine(
      this.code_dir,
      this.console,
      { include_paths: ["./"], config: "my-coffeelint-config.json" }
    ).run();

    expect(log).to.not.have.been.called
  });
});
