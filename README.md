![Tambo banner image](https://github.com/massdonati/tambo/raw/master/assets/Banner.jpg)

![supported platforms](https://img.shields.io/badge/platforms-ios%20macOS%20tvOS%20watchOS-blue.svg?longCache=true&style=flat) ![programming language](https://img.shields.io/badge/swift-4.2-orange.svg?longCache=true&style=flat) ![cocoapod](https://img.shields.io/badge/cocoapods-supported-red.svg?longCache=true&style=flat) ![cocoapod](https://img.shields.io/badge/licence-MIT-green.svg?longCache=true&style=flat)



Tambo is a versatile logging framework currently in development.

## Installation
### Cocoapods
`pod 'Tambo'`

## Usage
### Basic

To start using `Tambo` right away all you need to do is:

1. `import Tambo`: this is usually done in your `AppDelegate`.
2. create a global constant with the `default` Tambo singleton like so `let log = Tambo.default`.
3. start calling the logging api to se the logs in the Xcode console.

### Full power

In order to use Tambo the way it's ment to be used, you need to create an instance with an identifier (helpfull to track the logging source in complex application that could have multiple Tambo instances).

```
let log = Tambo(identifier: "com.my.logger")
```

Then you need to create a strem object which, in Tambo language, defines where you want the logs to be displayed/sent to. In this example let's create an Xcode console stream using the `TConsoleStream` class:

```
let console = TConsoleStream(identifier: "com.my.console", printMode: .print)
```
Once we have created a stream we can configure it as much as we want and after that we're ready to add it to the `Tambo` instance in order for it to start logging.

```
log.add(stream: console)
```

Now we're ready to show some logs to the console. YAY!! 🎉🎉🎉🎉

## Log levels
In priority order:

1. error
2. warning
3. info
4. debug
5. verbose

## Logging Apis
Every log level has a correspondent method in the `Tambo` class.
When you call that api you can pass anything as a first parameter and optionally a `context`. 

```
log.info("Request succeeded")
log.info(["one", "two", 3])
log.info(UIViewController(), context: ["url": request.url])
```
## Stream Apis

## Roadmap
1. CI integration
3. Proven carthage support
4. Linux testing
 

## Desclimer
This framework is still in development you're welcome to 

1. try it out
2. contribute
3. submit issues/feature request