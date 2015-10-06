#include "Charge.h"
#include "Engine.h"
#include "Area.h"
#include "Gang.h"
#include "Module.h"

using namespace eufe;

Charge::Charge(std::shared_ptr<Engine> engine, TypeID typeID, std::shared_ptr<Item> owner) : Item(engine, typeID, owner)
{
}

Charge::~Charge()
{
}

Environment Charge::getEnvironment()
{
	Environment environment;
	environment["Self"] = shared_from_this();

	std::shared_ptr<Item> module = getOwner();
	std::shared_ptr<Item> ship = module ? module->getOwner() : nullptr;
	std::shared_ptr<Item> character = ship ? ship->getOwner() : nullptr;
	std::shared_ptr<Item> gang = character ? character->getOwner() : nullptr;
	std::shared_ptr<Area> area = engine_.lock()->getArea();
	if (character)
		environment["Char"] = character;
	if (ship)
		environment["Ship"] = ship;
	if (gang)
		environment["Gang"] = gang;
	if (area)
		environment["Area"] = area;
	if (module)
		environment["Other"] = module;
	
	return environment;
}