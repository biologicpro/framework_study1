package context9.ecs.systems;

import context9.ecs.BaseSystem;
import context9.ecs.World;
import context9.ecs.resource.Time;

/** Writes Time resource each frame (init phase) */
class TimeSystem extends BaseSystem {
  public function new() {
    super({ name: "TimeSystem", resourceWrites: [Time], phase: "init" });
  }

  override public function update(world:World, dt:Float):Void {
    var t = world.getResource(Time);
    if (t == null) { t = new Time(); world.setResource(Time, t); }
    t.dt = dt;
    t.elapsed += dt;
  }
}
