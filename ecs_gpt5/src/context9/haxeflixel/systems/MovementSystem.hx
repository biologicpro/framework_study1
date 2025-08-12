package context9.haxeflixel.systems;

import context9.ecs.BaseSystem;
import context9.ecs.World;
import context9.haxeflixel.components.Position;
import context9.haxeflixel.components.Velocity;

class MovementSystem extends BaseSystem {
  public function new() {
    super({
      name: "MovementSystem",
      required: [Position, Velocity],
      reads: [Position, Velocity],
      writes: [Position],
      phase: "logic"
    });
  }

  override public function update(world:World, dt:Float):Void {
    final q = world.query([Position, Velocity]);
    q.forEach(function(e) {
      final p = world.getComponent(e, Position);
      final v = world.getComponent(e, Velocity);
      if (p != null && v != null) {
        p.x += v.vx * dt;
        p.y += v.vy * dt;
      }
    });
  }
}
