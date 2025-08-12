package context9.ecs.event;

import haxe.ds.ArraySort;

interface IEventBus {
  public function typeKey():String;
  public function swap():Void; // swap inbox/outbox at frame start
  public function clear():Void; // clear both buffers
}

class EventBus<T> implements IEventBus {
  final _typeKey:String;
  var inbox:Array<T> = [];
  var outbox:Array<T> = [];

  public inline function new(typeKey:String) {
    _typeKey = typeKey;
  }

  public inline function typeKey():String return _typeKey;

  // Producer API
  public inline function emit(value:T):Void outbox.push(value);

  // Consumer API (reads from inbox only)
  public inline function forEach(fn:T->Void):Void {
    for (e in inbox) fn(e);
  }

  public inline function toArray():Array<T> return inbox.copy();

  // Frame lifecycle
  public inline function swap():Void {
    var tmp = inbox;
    inbox = outbox;
    outbox = tmp;
    outbox.resize(0); // clear previous inbox now used as outbox
  }

  public inline function clear():Void {
    inbox.resize(0);
    outbox.resize(0);
  }
}
