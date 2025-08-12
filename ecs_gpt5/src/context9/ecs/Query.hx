package context9.ecs;

/**
 * Query finds entities that match a set of required component types.
 */
class Query {
  final world:World;
  final reqKeys:Array<String>;

  public function new(world:World, required:Array<Class<Dynamic>>) {
    this.world = world;
    this.reqKeys = [for (c in required) world.typeKeyOf(c)];
  }

  public inline function forEach(fn:Int->Void):Void {
    var smallest:IComponentPool = null;
    for (k in reqKeys) {
      var pool = world.getPoolByKey(k);
      if (pool == null) return; // nothing matches
      if (smallest == null || pool.size() < smallest.size()) smallest = pool;
    }
    if (smallest == null) return;

    for (e in smallest.entityIds()) {
      var ok = true;
      for (k in reqKeys) if (world.getPoolByKey(k) != null) {
        if (!world.getPoolByKey(k).has(e)) { ok = false; break; }
      }
      if (ok && world.isAlive(e)) fn(e);
    }
  }

  public inline function first():Null<Int> {
    var result:Null<Int> = null;
    forEach(function(e) { if (result == null) result = e; });
    return result;
  }
}
