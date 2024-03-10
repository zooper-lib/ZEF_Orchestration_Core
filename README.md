# zef_orchestration_core

This Dart library provides a flexible and efficient way to handle and orchestrate requests using a command and query pattern. It's designed to facilitate the separation of command and query operations, enabling clear and maintainable code structures for complex applications.

## Features

- Generic Request Handling: Define request handlers that process specific types of requests and return corresponding results.
- Command and Query Separation: Separate handling of command and query operations for clear distinction between actions that change state and those that retrieve data.
- Asynchronous Support: Built-in support for asynchronous operations, enabling non-blocking I/O operations.
- Singleton Orchestrator: Central orchestrator instance to manage command and query handlers, ensuring a single point of orchestration.

## Getting Started

### Installation

To integrate this library into your Dart or Flutter project, add the following dependency to your `pubspec.yaml` file:

```yaml
dependencies:
  your_library_name: latest_version
```

## Quick Start

### Initializing the Orchestrator

Before using the `Orchestrator`, initialize it:

```dart
void main() {
  OrchestratorBuilder().build();
}
```

If you have implemented a custom `OrchestratorAdapter`, you should initialize the `Orchestrator` with using it:

```dart
void main() {
  OrchestratorBuilder()
    .withAdapter(YourCustomOrchestratorAdapter())
    .build();
}
```

### Defining Requests and Handlers

Create your command and query requests along with their respective handlers. Each handler should implement the corresponding abstract handler class:

```dart
class SampleCommand extends Command {
  // Implementation details
}

class SampleCommandHandler extends CommandHandler<SampleCommand> {
  @override
  Future<void> call(SampleCommand command) async {
    // Command handling logic
  }
}
```

### Registering Handlers with the Orchestrator

Register your command and query handlers with the orchestrator to enable their processing:

```dart
Orchestrator.I.registerCommandHandler(SampleCommandHandler());
```

### Using the Orchestrator to Send Commands and Queries

Send commands and queries through the orchestrator and handle the results as needed:

```dart
await Orchestrator.I.publish(SampleCommand());
// For queries with expected results
var queryResult = await Orchestrator.I.send(SampleQuery());
```

## Registering Handlers with a factory

You can also register your `RequestHandler` via a factory, so the instances won't be stored in memory. This can reduce the memory usage, but keep in mind that it can lead the decreased performance when sending or publish a request, as the `Orchestrator` tries to resolve an instance.
However if you register your `RequestHandler` via dependency injection as a `Lazy`, the `RequestHandler` instance will be resolved at the first time it is needed. This decreases startup time and memory usage. So we recommend going that way.

```dart
Orchestrator.I.registerCommandHandlerFactory(() => SampleCommandHandler());
```

Note: this is now a factory, which directly returns an instance every time we send the appropriate `Command`.

## Contributing

Contributions to this library are welcome. Please feel free to submit pull requests or open issues to discuss proposed changes or enhancements.
