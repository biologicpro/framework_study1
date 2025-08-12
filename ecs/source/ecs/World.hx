package ecs;

import ecs.systems.System;

/**
 * The World is the central container for all entities, components, and systems.
 * It manages the entire ECS state and orchestrates the updates.
 */
class World
{
	// Entity Management
	private var nextEntityId:Entity = 0;
	private var activeEntities:Array<Entity> = [];

	// Component Management
	private var components:Map<Entity, Map<Class<IComponent>, IComponent>> = [];

	// System Management
	private var systems:Array<System> = [];

	public function new() {}

	// =====================================================================================
	// Entity Methods
	// =====================================================================================

	/**
	 * Creates a new, empty entity.
	 * @return The ID of the newly created entity.
	 */
	public function createEntity():Entity
	{
		var entity = nextEntityId++;
		activeEntities.push(entity);
		components.set(entity, new Map<Class<IComponent>, IComponent>());
		return entity;
	}

	// =====================================================================================
	// Component Methods
	// =====================================================================================

	/**
	 * Adds a component instance to an entity.
	 * @param entity The entity to add the component to.
	 * @param component The component instance to add.
	 */
	public function addComponent(entity:Entity, component:IComponent):Void
	{
		if (components.exists(entity))
		{
			components.get(entity).set(Type.getClass(component), component);
		}
	}

	/**
	 * Retrieves a component from an entity by its class type.
	 * @param entity The entity to get the component from.
	 * @param componentType The class of the component to retrieve (e.g., PositionComponent).
	 * @return The component instance, or null if the entity does not have that component.
	 */
	public function getComponent<T:IComponent>(entity:Entity, componentType:Class<T>):T
	{
		if (components.exists(entity))
		{
			return untyped components.get(entity).get(componentType);
		}
		return null;
	}

	/**
	 * Checks if an entity has a specific component.
	 * @param entity The entity to check.
	 * @param componentType The class of the component to check for.
	 * @return True if the entity has the component, false otherwise.
	 */
	public function hasComponent<T:IComponent>(entity:Entity, componentType:Class<T>):Bool
	{
		if (!components.exists(entity)) return false;
		return untyped components.get(entity).exists(componentType);
	}

	/**
	 * Returns all active entities.
	 */
	public function getEntities():Array<Entity>
	{
		return activeEntities.copy();
	}

	// =====================================================================================
	// System Methods
	// =====================================================================================

	/**
	 * Adds a system to the world.
	 * @param system The system to add.
	 */
	public function addSystem(system:System):Void
	{
		systems.push(system);
	}

	// =====================================================================================
	// Main Update Loop
	// =====================================================================================

	/**
	 * Updates all systems in the world.
	 * This should be called from your main game loop (e.g., FlxState.update()).
	 * @param elapsed The time in seconds since the last frame.
	 */
	public function update(elapsed:Float):Void
	{
		for (system in systems)
		{
			system.update(elapsed);
		}
	}
}
