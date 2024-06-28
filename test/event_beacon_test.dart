import 'package:event_beacon/event_beacon.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EventBus', () {
    late EventBeacon eventBus;

    setUp(() {
      eventBus = EventBeacon();
    });

    test('subscribe and trigger event', () {
      int callCount = 0;
      void handler(String event) {
        expect(event, equals('test'));
        callCount++;
      }

      eventBus.on<String>(handler);
      eventBus.emit('test');

      expect(callCount, equals(1));
    });

    test('subscribe with event name', () {
      int callCount = 0;
      void handler(String event) {
        expect(event, equals('test'));
        callCount++;
      }

      eventBus.on<String>(handler, eventName: 'TestEvent');
      eventBus.emit('test', eventName: 'TestEvent');

      expect(callCount, equals(1));
    });

    test('unsubscribe', () {
      int callCount = 0;
      void handler(String event) {
        callCount++;
      }

      eventBus.on<String>(handler);
      eventBus.emit('test');
      expect(callCount, equals(1));

      eventBus.off<String>(handler);
      eventBus.emit('test');
      expect(callCount, equals(1)); // Should not increase
    });

    test('unsubscribe with event name', () {
      int callCount = 0;
      void handler(String event) => callCount++;

      eventBus.on<String>(handler, eventName: 'TestEvent');
      eventBus.emit('test', eventName: 'TestEvent');
      expect(callCount, equals(1));

      eventBus.off<String>(handler, eventName: 'TestEvent');
      eventBus.emit('test', eventName: 'TestEvent');
      expect(callCount, equals(1)); // Should not increase

      // Test that the handler is truly unsubscribed
      eventBus.on<String>(handler, eventName: 'TestEvent');
      eventBus.emit('test', eventName: 'TestEvent');
      expect(callCount, equals(2)); // Should increase now
    });

    test('multiple subscribers', () {
      int callCount1 = 0;
      int callCount2 = 0;
      void handler1(String event) => callCount1++;
      void handler2(int event) => callCount2++;

      eventBus.on<String>(handler1);
      eventBus.on<int>(handler2);

      eventBus.emit('test');
      eventBus.emit(42);

      expect(callCount1, equals(1));
      expect(callCount2, equals(1));
    });

    test('event type mismatch', () {
      int callCount = 0;
      void handler(String event) => callCount++;

      eventBus.on<String>(handler);
      eventBus.emit(42); // Int instead of String

      expect(callCount, equals(0)); // Should not be called
    });

    test('dispose prevents further events', () {
      int callCount = 0;
      void handler(String event) => callCount++;

      eventBus.on<String>(handler);
      eventBus.emit('test');
      expect(callCount, equals(1));

      eventBus.dispose();

      // These should not throw errors, but also should not increase callCount
      eventBus.on<String>(handler);
      eventBus.emit('test');
      eventBus.off<String>(handler);

      expect(callCount, equals(1)); // Should not increase after dispose
    });

    test('subscribe and trigger without event name', () {
      int callCount = 0;
      void handler(String event) => callCount++;

      eventBus.on<String>(handler);
      eventBus.emit('test');
      expect(callCount, equals(1));

      eventBus.off<String>(handler);
      eventBus.emit('test');
      expect(callCount, equals(1)); // Should not increase
    });

    test('multiple subscribers with same event type', () {
      int callCount1 = 0;
      int callCount2 = 0;
      void handler1(String event) => callCount1++;
      void handler2(String event) => callCount2++;

      eventBus.on<String>(handler1);
      eventBus.on<String>(handler2);

      eventBus.emit('test');

      expect(callCount1, equals(1));
      expect(callCount2, equals(1));
    });

    test('unsubscribe non-existent handler', () {
      void handler(String event) {}

      // This should not throw an error
      eventBus.off<String>(handler);
    });

    test('trigger event with no subscribers', () {
      // This should not throw an error
      eventBus.emit('test');
      eventBus.emit(42);
    });

    test('subscribe same handler multiple times', () {
      int callCount = 0;
      void handler(String event) => callCount++;

      eventBus.on<String>(handler);
      eventBus.on<String>(handler);

      eventBus.emit('test');

      expect(callCount, equals(2)); // Handler is called twice
    });
  });
}
