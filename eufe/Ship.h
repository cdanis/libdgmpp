#pragma once
#include "Item.h"
#include "Module.h"
#include "CapacitorSimulator.h"
#include "HeatSimulator.h"
#include "DamagePattern.h"

namespace eufe {

	class Ship : public Item
	{
	public:
		enum ScanType
		{
			SCAN_TYPE_RADAR,
			SCAN_TYPE_LADAR,
			SCAN_TYPE_MAGNETOMETRIC,
			SCAN_TYPE_GRAVIMETRIC,
			SCAN_TYPE_MULTISPECTRAL
		};
		Ship(std::shared_ptr<Engine> engine, TypeID typeID, std::shared_ptr<Character> owner = nullptr);
		virtual ~Ship(void);
		std::shared_ptr<Ship> shared_from_this() {
			return std::static_pointer_cast<Ship>(Item::shared_from_this());
		}

		std::shared_ptr<Module> addModule(TypeID typeID, bool force = false);
		std::shared_ptr<Module> replaceModule(std::shared_ptr<Module> oldModule, TypeID typeID);
		ModulesList addModules(const std::list<TypeID>& typeIDs);
		void removeModule(std::shared_ptr<Module> module);
		
		std::shared_ptr<Drone> addDrone(TypeID typeID);
		void removeDrone(std::shared_ptr<Drone> drone);
		
		const ModulesList& getModules();
		void getModules(Module::Slot slot, std::insert_iterator<ModulesList> outIterator);
		const DronesList& getDrones();
		const ModulesList& getProjectedModules();
		const DronesList& getProjectedDrones();
		bool canFit(std::shared_ptr<Module> module);
		bool isDisallowedAssistance();
		bool isDisallowedOffensiveModifiers();

		virtual Environment getEnvironment();
		
		virtual void reset();
		
		virtual void addEffects(Effect::Category category);
		virtual void removeEffects(Effect::Category category);
		
		virtual void addLocationGroupModifier(std::shared_ptr<Modifier> modifier);
		virtual void addLocationRequiredSkillModifier(std::shared_ptr<Modifier> modifier);

		
		void addProjectedModule(std::shared_ptr<Module> module);
		void removeProjectedModule(std::shared_ptr<Module> module);
		void addProjectedDrone(std::shared_ptr<Drone> drone);
		void removeProjectedDrone(std::shared_ptr<Drone> drone);
		
		std::shared_ptr<CapacitorSimulator> getCapacitorSimulator();
		std::shared_ptr<HeatSimulator> getHeatSimulator();
		const DamagePattern& getDamagePattern();
		void setDamagePattern(const DamagePattern& damagePattern);
		
		//Calculations
		
		int getNumberOfSlots(Module::Slot slot);
		int getFreeSlots(Module::Slot slot);
		int getUsedSlots(Module::Slot slot);
		int getNumberOfHardpoints(Module::Hardpoint hardpoint);
		int getFreeHardpoints(Module::Hardpoint hardpoint);
		int getUsedHardpoints(Module::Hardpoint hardpoint);
		
		float getCalibrationUsed();
		float getTotalCalibration();
		float getPowerGridUsed();
		float getTotalPowerGrid();
		float getCpuUsed();
		float getTotalCpu();
		float getDroneBandwidthUsed();
		float getTotalDroneBandwidth();
		float getDroneBayUsed();
		float getTotalDroneBay();

		
		//Capacitor
		float getCapCapacity();
		bool isCapStable();
		float getCapLastsTime();
		float getCapStableLevel();
		float getCapUsed();
		float getCapRecharge();
		
		//Tank
		const Resistances& getResistances();
		const Tank& getTank();
		const Tank& getEffectiveTank();
		const Tank& getSustainableTank();
		const Tank& getEffectiveSustainableTank();
		
		const HitPoints& getHitPoints();
		const HitPoints& getEffectiveHitPoints();
		
		float getShieldRecharge();

		//DPS
		float getWeaponDps();
		float getWeaponVolley();
		float getDroneDps();
		float getDroneVolley();
		
		//Mobility
		float getAlignTime();
		float getWarpSpeed();
		float getMaxWarpDistance();
		float getVelocity();
		float getSignatureRadius();
		float getMass();
		float getVolume();
		float getAgility();
		float getMaxVelocityInOrbit(float r);
		float getOrbitRadiusWithLinearVelocity(float v);
		float getOrbitRadiusWithAngularVelocity(float v);
		
		//Targeting
		int getMaxTargets();
		float getMaxTargetRange();
		float getScanStrength();
		ScanType getScanType();
		float getProbeSize();
		float getScanResolution();
		
		//Drones
		int getMaxActiveDrones();
		int getActiveDrones();

		//Other
		void updateHeatDamage();
		
		friend std::ostream& operator<<(std::ostream& os, Ship& ship);
		
	private:
		ModulesList modules_;
		DronesList drones_;
		ModulesList projectedModules_;
		DronesList projectedDrones_;
		std::shared_ptr<CapacitorSimulator> capacitorSimulator_;
		std::shared_ptr<HeatSimulator> heatSimulator_;
		DamagePattern damagePattern_;
		
		Resistances resistances_;
		Tank tank_;
		Tank effectiveTank_;
		Tank sustainableTank_;
		Tank effectiveSustainableTank_;
		HitPoints hitPoints_;
		HitPoints effectiveHitPoints_;
		float shieldRecharge_;
		
		float weaponDps_;
		float weaponVolley_;
		float droneDps_;
		float droneVolley_;
		
		enum {
			UNKNOWN = -1,
			ALLOWED,
			DISALLOWED
		} disallowAssistance_, disallowOffensiveModifiers_;
		
		void calculateDamageStats();
		void updateActiveStatus();
	};
}