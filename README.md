# EventBeacon Flutter

A lightweight, typed event system for Flutter applications. EventBeacon provides a simple way to implement publish-subscribe patterns in your Flutter projects.

## Features

- Typed events for compile-time safety
- Support for named events
- Easy-to-use API with `on`, `off`, and `emit` methods
- Built on top of Flutter's `ChangeNotifier` for efficient updates

## Getting started

Add `event_beacon` to your `pubspec.yaml` file:

```yaml
dependencies:
  event_beacon: any
```

## Usage

Here's a simple example of how to use EventBeacon:

```dart
import 'package:event_beacon/event_beacon.dart';

void main() {
  final beacon = EventBeacon();

  beacon.on<String>((message) {
    print('Received message: $message');
  });

  beacon.emit('Hello, EventBeacon!');
}
```

## Examples

For more advanced usage and examples, check out the [example](example) folder in the package repository.

## Additional Information

For more information on using this package, please refer to the [API documentation](https://pub.dev/documentation/watchable/latest/).

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.