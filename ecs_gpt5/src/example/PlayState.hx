package example;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import context9.haxeflixel.EcsState;
import context9.ecs.schedulers.UltraThinkScheduler;
import context9.haxeflixel.components.Position;
import context9.haxeflixel.components.Velocity;
import context9.haxeflixel.components.SpriteComponent;
import context9.haxeflixel.systems.MovementSystem;
import context9.haxeflixel.systems.SpriteSyncSystem;

class PlayState extends EcsState {
  public function new() {
    super(new UltraThinkScheduler());
  }

  override public function create():Void {
    super.create();

    world
      .addSystem(new MovementSystem())
      .addSystem(new SpriteSyncSystem(this));

    final e = world.createEntity();
    final sp = new FlxSprite(0, 0);
    sp.makeGraphic(16, 16, 0xFF00FF00);

    world.addComponent(e, Position, new Position(32, 32));
    world.addComponent(e, Velocity, new Velocity(60, 30));
    world.addComponent(e, SpriteComponent, new SpriteComponent(sp));
  }
}
