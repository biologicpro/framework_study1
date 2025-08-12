package;

import flixel.FlxState;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.FlxG;

// Import all ECS classes
import ecs.World;
import ecs.systems.MovementSystem;
import ecs.systems.RenderSystem;
import ecs.systems.InputSystem;
import ecs.systems.BoundsSystem;
import ecs.components.PositionComponent;
import ecs.components.VelocityComponent;
import ecs.components.SpriteComponent;
import ecs.components.InputComponent;
import ecs.components.BoundsCheckComponent;

/**
 * A PlayState demonstrating a more complete example of the ECS framework.
 * - A player-controlled green square.
 * - 20 autonomous red squares.
 * - All squares wrap around the screen bounds.
 */
class PlayState extends FlxState
{
	private var world:World;

	override public function create()
	{
		super.create();

		// 1. Initialize the World
		world = new World();

		// 2. Add Systems
		// The order can be important! Input -> Movement -> Bounds -> Render is a good flow.
		world.addSystem(new InputSystem(world));
		world.addSystem(new MovementSystem(world));
		world.addSystem(new BoundsSystem(world));
		world.addSystem(new RenderSystem(world, this));

		// 3. Create the Player Entity
		createPlayer();

		// 4. Create Enemy Entities
		for (i in 0...20)
		{
			createEnemy();
		}
	}

	private function createPlayer():Void
	{
		var player = world.createEntity();
		
		// Player's components
		world.addComponent(player, new PositionComponent(FlxG.width / 2, FlxG.height / 2));
		world.addComponent(player, new VelocityComponent(0, 0)); // Starts stationary
		
		var playerSprite = new FlxSprite().makeGraphic(20, 20, FlxColor.GREEN);
		world.addComponent(player, new SpriteComponent(playerSprite));
		
		// Components that tag the entity for specific systems
		world.addComponent(player, new InputComponent());
		world.addComponent(player, new BoundsCheckComponent());
	}

	private function createEnemy():Void
	{
		var enemy = world.createEntity();

		// Random position and velocity
		var randX = FlxG.random.float(0, FlxG.width);
		var randY = FlxG.random.float(0, FlxG.height);
		var randVX = FlxG.random.float(-100, 100);
		var randVY = FlxG.random.float(-100, 100);

		world.addComponent(enemy, new PositionComponent(randX, randY));
		world.addComponent(enemy, new VelocityComponent(randVX, randVY));

		var enemySprite = new FlxSprite().makeGraphic(15, 15, FlxColor.RED);
		world.addComponent(enemy, new SpriteComponent(enemySprite));

		// Enemies are also checked for screen bounds
		world.addComponent(enemy, new BoundsCheckComponent());
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		// 5. Update the world. This single call drives all system logic.
		world.update(elapsed);
	}
}
