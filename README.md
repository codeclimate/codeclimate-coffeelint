# Code Climate CoffeeLint Engine

[![Code Climate](https://codeclimate.com/repos/558418dce30ba07779007ea9/badges/6127feca9d51fedf2c6a/gpa.svg)](https://codeclimate.com/repos/558418dce30ba07779007ea9/feed)

`codeclimate-CoffeeLint` is a Code Climate engine that wraps [CoffeeLint](http://www.coffeelint.org/). You can run it on your command line using the Code Climate CLI, or on our hosted analysis platform.

CoffeeLint is a style checker that helps keep CoffeeScript code clean and consistent. By default, CoffeeLint will help ensure you are writing idiomatic CoffeeScript, but every rule is optional and configurable so it can be tuned to fit your preferred coding style. To override any of CoffeeLint's default options, generate a [configuration file](http://www.coffeelint.org/#usage) and tweak it as needed.

### Installation

1. If you haven't already, [install the Code Climate CLI](https://github.com/codeclimate/codeclimate).
2. Run `codeclimate engines:enable coffeelint`. This command both installs the engine and enables it in your `.codeclimate.yml` file.
3. You're ready to analyze! Browse into your project's folder and run `codeclimate analyze`.

### Need help?

For help with CoffeeLint, [check out their documentation](http://www.coffeelint.org/).

If you're running into a Code Climate issue, first look over this project's [GitHub Issues](https://github.com/codeclimate/codeclimate-coffeelint/issues), as your question may have already been covered. If not, [go ahead and open a support ticket with us](https://codeclimate.com/help).
