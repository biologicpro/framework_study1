Events are double-buffered per type.
- Producers call world.emitEvent(EventType, payload) which appends to the outbox for the current frame.
- Consumers iterate world.events(EventType).forEach(...) which reads from the inbox (events produced last frame).
- At the start of each world.update, all known event buses swap (inbox<->outbox), then outbox is cleared.
- Because of double-buffering, event writes never conflict with event reads in the same frame.
