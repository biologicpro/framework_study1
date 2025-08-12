package context9.ecs;

import haxe.ds.IntMap;
import haxe.ds.StringMap;

/**
 * World manages entities, components, systems, and scheduling.
 * Simplicity-first implementation influenced by Artemis-ODB/EnTT/Specs.
 */
class World {
  // Resources and Events
  var _resources:haxe.ds.StringMap<Dynamic> = new StringMap();
  var _eventBuses:haxe.ds.StringMap<context9.ecs.event.IEventBus> = new StringMap();
  static var __typeKeyCache:StringMap<String> = new StringMap();

  public static inline function typeKeyStatic(c:Class<Dynamic>):String {
    var key = Type.getClassName(c);
    var cached = __typeKeyCache.get(key);
    if (cached == null) { __typeKeyCache.set(key, key); return key; }
    return cached;
  }

  public inline function typeKeyOf(c:Class<Dynamic>):String return typeKeyStatic(c);

  var _nextEntityId:Int = 1;
  var _alive:IntMap<Bool> = new IntMap();
  var _pools:StringMap<IComponentPool> = new StringMap();
  var _systems:Array<ISystem> = [];
  var _scheduler:IScheduler;

  public function new(?scheduler:IScheduler) {
    this._scheduler = scheduler;
  }

  public function setScheduler(s:IScheduler):World { _scheduler = s; return this; }

  public function addSystem(system:ISystem):World {
    _systems.push(system);
    return this;
  }

  public function systems():Array<ISystem> return _systems;

  public function createEntity():Int {
    final id = _nextEntityId++;
    _alive.set(id, true);
    return id;
  }

  public function destroyEntity(entity:Int):Void {
    if (!_alive.exists(entity)) return;
    _alive.remove(entity);
    for (pool in _pools) pool.removeAllForEntity(entity);
  }

  public function isAlive(entity:Int):Bool {
    return _alive.exists(entity);
  }

  public function addComponent<T>(entity:Int, c:Class<T>, value:T):World {
    final key = typeKeyOf(cast c);
    var pool = _pools.get(key);
    if (pool == null) { pool = new ComponentPool<T>(key); _pools.set(key, pool); }
    cast(pool, ComponentPool<T>).set(entity, value);
    return this;
  }

  public function removeComponent<T>(entity:Int, c:Class<T>):Bool {
    final key = typeKeyOf(cast c);
    var pool = _pools.get(key);
    return pool != null ? pool.remove(entity) : false;
  }

  public function getComponent<T>(entity:Int, c:Class<T>):Null<T> {
    final key = typeKeyOf(cast c);
    var pool = _pools.get(key);
    return pool != null ? cast(cast pool, ComponentPool<T>).get(entity) : null;
  }

  public function has<T>(entity:Int, c:Class<T>):Bool {
    final key = typeKeyOf(cast c);
    var pool = _pools.get(key);
    return pool != null && pool.has(entity);
  }

  public function getPool<T>(c:Class<T>):ComponentPool<T> {
    final key = typeKeyOf(cast c);
    var pool = _pools.get(key);
    if (pool == null) { pool = new ComponentPool<T>(key); _pools.set(key, pool); }
    return cast pool;
  }

  public inline function getPoolByKey(key:String):Null<IComponentPool> return _pools.get(key);

  public function query(required:Array<Class<Dynamic>>):Query {
    return new Query(this, required);
  }

  // --- Resource API ---
  public function setResource<T>(c:Class<T>, value:T):World {
    final key = typeKeyOf(cast c);
    _resources.set(key, value);
    return this;
  }

  public function getResource<T>(c:Class<T>):Null<T> {
    return cast _resources.get(typeKeyOf(cast c));
  }

  public function hasResource<T>(c:Class<T>):Bool {
    return _resources.exists(typeKeyOf(cast c));
  }

  // --- Event API ---
  inline function ensureEventBus<T>(c:Class<T>):context9.ecs.event.EventBus<T> {
    final key = typeKeyOf(cast c);
    var bus = cast _eventBuses.get(key);
    if (bus == null) {
      bus = new context9.ecs.event.EventBus<T>(key);
      _eventBuses.set(key, bus);
    }
    return cast bus;
  }

  public function emitEvent<T>(c:Class<T>, value:T):Void {
    ensureEventBus(c).emit(value);
  }

  public function events<T>(c:Class<T>):context9.ecs.event.EventBus<T> {
    return ensureEventBus(c);
  }

  public function update(dt:Float):Void {
    // Swap event buses at start of frame to make last-frame outbox the inbox
    for (bus in _eventBuses) bus.swap();

    if (_scheduler == null) throw 'World.update called without a scheduler. Call setScheduler(...)';
    _scheduler.run(this, _systems, dt);
  }
}
