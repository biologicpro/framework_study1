Resources are singletons keyed by type and stored in World. Systems can declare resourceReads/resourceWrites for conflict-aware scheduling.

Example:
class Time { public var dt:Float = 0; public function new(){} }
world.setResource(Time, new Time());

class TimeSystem extends BaseSystem {
  public function new() {
    super({ name: "TimeSystem", resourceWrites: [Time], phase: "init" });
  }
  override public function update(world:World, dt:Float):Void {
    final t = world.getResource(Time);
    t.dt = dt;
  }
}
