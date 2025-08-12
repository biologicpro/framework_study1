package context9.haxeflixel.systems;

import context9.ecs.BaseSystem;
import context9.ecs.World;
import context9.haxeflixel.components.Position;
import context9.haxeflixel.components.SpriteComponent;
import context9.haxeflixel.components.Velocity;
import flixel.FlxSprite;

/** Emits a Damage event for the first entity as a demo of event writes. */
class SpawnerSystem extends BaseSystem {
  public function new() {
    super({ name: "SpawnerSystem", eventWrites: [context9.ecs.event.Events.Damage], phase: "logic" });
  }

  override public function update(world:World, dt:Float):Void {
    var first = world.query([Position]).first();
    if (first != null) {
      world.emitEvent(context9.ecs.event.Events.Damage, { entity: first, amount: 1 });
    }
  }
}
