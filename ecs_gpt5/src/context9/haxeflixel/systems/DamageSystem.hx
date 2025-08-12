package context9.haxeflixel.systems;

import context9.ecs.BaseSystem;
import context9.ecs.World;
import context9.haxeflixel.components.Position;
import context9.ecs.event.Events.Damage;

/** Applies damage events to entities that have Position (for demo purposes). */
class DamageSystem extends BaseSystem {
  public function new() {
    super({ name: "DamageSystem", eventReads: [Damage], phase: "logic" });
  }

  override public function update(world:World, dt:Float):Void {
    final bus = world.events(Damage);
    bus.forEach(function(ev:Damage) {
      if (world.isAlive(ev.entity) && world.has(ev.entity, Position)) {
        // Real game would subtract from Health; here we simply nudge the entity
        var p = world.getComponent(ev.entity, Position);
        if (p != null) p.x += 2; // tiny visual feedback
      }
    });
  }
}
