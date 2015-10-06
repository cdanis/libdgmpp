#pragma once
#include "Item.h"

namespace eufe {
	
	class Module : public Item
	{
	public:
		enum Slot
		{
			SLOT_UNKNOWN = -1,
			SLOT_NONE = 0,
			SLOT_HI,
			SLOT_MED,
			SLOT_LOW,
			SLOT_RIG,
			SLOT_SUBSYSTEM,
			SLOT_STRUCTURE,
			SLOT_MODE,
		};

		enum State
		{
			STATE_OFFLINE,
			STATE_ONLINE,
			STATE_ACTIVE,
			STATE_OVERLOADED
		};
		
		enum Hardpoint
		{
			HARDPOINT_NONE = 0,
			HARDPOINT_LAUNCHER,
			HARDPOINT_TURRET
		};
		Module(std::shared_ptr<Engine> engine, TypeID typeID, std::shared_ptr<Item> owner = nullptr);
		virtual ~Module(void);
		std::shared_ptr<Module> shared_from_this() {
			return std::static_pointer_cast<Module>(Item::shared_from_this());
		}

        typedef std::invalid_argument BadTargetException;
        typedef std::invalid_argument BadStateException;

		//virtual Attribute* getAttribute(TypeID attributeID);

		Slot getSlot();
		Hardpoint getHardpoint();
		virtual bool canHaveState(State state);
		State getState();
		virtual void setState(State state);

		virtual Environment getEnvironment();

		virtual void addEffects(Effect::Category category);
		virtual void removeEffects(Effect::Category category);
		
		virtual void reset();
		
		std::shared_ptr<Charge> setCharge(TypeID typeID);
		void clearCharge();
		std::shared_ptr<Charge> getCharge();
		const std::vector<TypeID>& getChargeGroups();
		int getChargeSize();
		void removeCharge();
		bool canFit(std::shared_ptr<Charge> charge);
		bool requireTarget();
		void setTarget(std::shared_ptr<Ship> target = nullptr);
		void clearTarget();
		std::shared_ptr<Ship> getTarget();
		float getReloadTime();
		
		//Calculations
		
		float getCycleTime();
		float getRawCycleTime();
		
		int getCharges();
		int getShots();
		float getCapUse();
		
		float getVolley();
		float getDps();
		float getMaxRange();
		float getFalloff();
		float getTrackingSpeed();
		
		float getLifeTime();
		void setLifeTime(float lifeTime);
		

		friend std::ostream& operator<<(std::ostream& os, Module& module);
	protected:
		State state_;
		virtual void lazyLoad();

		
	private:
		bool canBeOnline_;
		bool canBeActive_;
		bool canBeOverloaded_;
		bool requireTarget_;
		bool forceReload_;
		Slot slot_;
		Hardpoint hardpoint_;
		std::shared_ptr<Charge> charge_;
		std::vector<TypeID> chargeGroups_;
		std::weak_ptr<Ship> target_;
		float reloadTime_;
		int shots_;
		
		float volley_;
		float dps_;
		float maxRange_;
		float falloff_;
		float trackingSpeed_;
		
		float lifeTime_;
		
		void calculateDamageStats();
	};
}