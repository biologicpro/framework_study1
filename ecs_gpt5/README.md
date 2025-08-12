context9 ECS for Haxe and HaxeFlixel

Overview
- Minimal, general-purpose Entity-Component-System for Haxe inspired by EnTT, Artemis-ODB, Specs/Legion, and Unity DOTS.
- Comes with two schedulers:
  - SequenceScheduler: runs systems in the order they are added (sequence thinking).
  - UltraThinkScheduler: groups by phase (init/logic/render), respects before/after hints via topological sort, and builds conflict-aware layers based on declared reads/writes.
- Includes a small adapter for HaxeFlixel with example components and systems.

Core concepts
- World: creates/destroys entities, attaches components, runs systems via a scheduler.
- Components: plain Haxe classes/struct-like objects stored by type.
- Systems: implement update(world, dt) and declare required/optional component types, read/write sets, and ordering hints.
- Query: iterate entities that have a given set of components.

HaxeFlixel integration
- EcsState extends FlxState and hosts a World. Call addSystem on world in create() and world.update(elapsed) is called each frame.
- Included components: Position, Velocity, SpriteComponent.
- Included systems: MovementSystem (logic), SpriteSyncSystem (render) syncing sprite position and adding sprite to the state.

Scheduling
- SequenceScheduler: simplest possible ordering.
- UltraThinkScheduler: phase buckets (init < logic < render), topological sort via before()/after(), and simple conflict-aware layering based on component reads/writes. Layers run sequentially here but are structured for potential parallelization.

Example (HaxeFlixel)
See src/example/PlayState.hx:
- Uses UltraThinkScheduler
- Adds MovementSystem (logic) and SpriteSyncSystem (render)
- Creates an entity with Position, Velocity, SpriteComponent and watches it move.

Design notes
- Component storage uses IntMap per type. This is simple and portable across Haxe targets.
- Queries choose the smallest pool as an anchor for iteration and then test membership in other required pools.
- World.typeKeyOf uses Type.getClassName for runtime type keys.

Extending
- Define your component as a simple class.
- Create a system by extending BaseSystem and overriding update(). Declare correct required/reads/writes for better scheduling.

License
MIT
