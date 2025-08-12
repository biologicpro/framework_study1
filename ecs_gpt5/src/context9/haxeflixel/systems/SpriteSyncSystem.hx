package context9.haxeflixel.systems;

import context9.ecs.BaseSystem;
import context9.ecs.World;
import context9.haxeflixel.components.Position;
import context9.haxeflixel.components.SpriteComponent;
import flixel.FlxState;

/**
 * Synchronizes Position to FlxSprite.x/y and ensures the sprite is added to the state once.
 * Phase: render.
 */
class SpriteSyncSystem extends BaseSystem {
  final state:FlxState;

  public function new(state:FlxState) {
    this.state = state;
    super({
      name: "SpriteSyncSystem",
      required: [SpriteComponent, Position],
      reads: [SpriteComponent, Position],
      writes: [SpriteComponent],
      phase: "render",
      after: ["MovementSystem"]
    });
  }

  override public function update(world:World, dt:Float):Void {
    final q = world.query([SpriteComponent, Position]);
    q.forEach(function(e) {
      final sc = world.getComponent(e, SpriteComponent);
      final p = world.getComponent(e, Position);
      if (sc == null || p == null) return;
      if (!sc.added) { state.add(sc.sprite); sc.added = true; }
      sc.sprite.x = p.x;
      sc.sprite.y = p.y;
    });
  }
}
