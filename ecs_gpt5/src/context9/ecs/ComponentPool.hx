package context9.ecs;

import haxe.ds.IntMap;

/**
 * IComponentPool is a runtime-erased storage for one component type.
 * Implementations should provide O(1) add/get/remove by entity id.
 */
interface IComponentPool {
  public function has(entity:Int):Bool;
  public function remove(entity:Int):Bool;
  public function removeAllForEntity(entity:Int):Void;
  public function entityIds():Iterator<Int>;
  public function size():Int;
  public function typeKey():String;
  // Dynamic accessors used by World to avoid generics at runtime
  public function getDynamic(entity:Int):Dynamic;
  public function setDynamic(entity:Int, value:Dynamic):Void;
}

/**
 * Generic component pool backed by IntMap.
 * Not the most cache-friendly, but simple and reliable across all targets.
 */
class ComponentPool<T> implements IComponentPool {
  final _typeKey:String;
  final _data:IntMap<T> = new IntMap();

  public inline function new(typeKey:String) {
    this._typeKey = typeKey;
  }

  public inline function typeKey():String return _typeKey;

  public inline function has(entity:Int):Bool return _data.exists(entity);

  public inline function get(entity:Int):Null<T> return _data.get(entity);

  public inline function set(entity:Int, value:T):Void _data.set(entity, value);

  public inline function remove(entity:Int):Bool return _data.remove(entity);

  public inline function removeAllForEntity(entity:Int):Void {
    _data.remove(entity);
  }

  public inline function entityIds():Iterator<Int> return _data.keys();

  public inline function size():Int {
    var n = 0; for (_ in _data) n++; return n;
  }

  // Dynamic API
  public inline function getDynamic(entity:Int):Dynamic return cast get(entity);
  public inline function setDynamic(entity:Int, value:Dynamic):Void set(entity, cast value);
}
