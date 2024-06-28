library event_beacon;

import 'package:flutter/foundation.dart';

/// A class that allows emitting events and subscribing to them.
class EventBeacon extends ChangeNotifier {
  /// List of subscribers to the events.
  final List<_EventSubscription> _subscribers = [];

  /// The last emitted event.
  Object? _lastEvent;

  /// The name of the last emitted event.
  String? _lastEventName;

  /// Indicates whether the EventBeacon has been disposed.
  bool _isDisposed = false;

  /// Constructor that adds a listener to notify subscribers.
  EventBeacon() {
    addListener(_notifySubscribers);
  }

  /// Emits an event to all subscribers.
  ///
  /// [event] is the event object to emit.
  /// [eventName] is an optional name for the event.
  void emit(Object event, {String? eventName}) {
    if (_isDisposed) return;
    _lastEvent = event;
    _lastEventName = eventName;
    notifyListeners();
  }

  /// Notifies all subscribers of the last emitted event.
  void _notifySubscribers() {
    final event = _lastEvent;
    final eventName = _lastEventName;
    _lastEvent = null;
    _lastEventName = null;
    if (event != null) {
      for (final subscription in _subscribers) {
        if ((eventName != null && subscription.eventName == eventName) ||
            (eventName == null &&
                subscription.eventName == null &&
                subscription.eventType == event.runtimeType)) {
          subscription.callSubscriber(event);
        }
      }
    }
  }

  /// Subscribes to an event of type [E].
  ///
  /// [subscriber] is the function to call when the event is emitted.
  /// [eventName] is an optional name for the event.
  void on<E>(void Function(E) subscriber, {String? eventName}) {
    if (_isDisposed) return;
    _subscribers.add(_EventSubscription<E>(subscriber, eventName));
  }

  /// Unsubscribes from an event of type [E].
  ///
  /// [subscriber] is the function that was used to subscribe.
  /// [eventName] is an optional name for the event.
  void off<E>(void Function(E) subscriber, {String? eventName}) {
    if (_isDisposed) return;
    _subscribers.removeWhere((subscription) =>
        subscription is _EventSubscription<E> &&
        subscription.subscriber == subscriber &&
        subscription.eventName == eventName);
  }

  /// Disposes the EventBeacon, clearing all subscribers.
  @override
  void dispose() {
    _isDisposed = true;
    _subscribers.clear();
    super.dispose();
  }
}

/// A class representing a subscription to an event.
class _EventSubscription<T> {
  /// The function to call when the event is emitted.
  final void Function(T) subscriber;

  /// The type of the event.
  final Type eventType;

  /// The name of the event.
  final String? eventName;

  /// Constructor for creating an event subscription.
  ///
  /// [subscriber] is the function to call when the event is emitted.
  /// [eventName] is an optional name for the event.
  _EventSubscription(this.subscriber, this.eventName) : eventType = T;

  /// Calls the subscriber function with the given event.
  ///
  /// [event] is the event object to pass to the subscriber.
  void callSubscriber(Object event) {
    if (event is T) {
      subscriber(event as T);
    }
  }
}
