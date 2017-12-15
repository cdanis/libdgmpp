/* ----------------------------------------------------------------------------
 * This file was automatically generated by SWIG (http://www.swig.org).
 * Version 3.0.12
 *
 * Do not make changes to this file unless you know what you are doing--modify
 * the SWIG interface file instead.
 * ----------------------------------------------------------------------------- */

package com.dgmpp.jdgmpp;

public class Module extends Type {
  private transient long swigCPtr;

  protected Module(long cPtr, boolean cMemoryOwn) {
    super(dgmppJNI.Module_SWIGUpcast(cPtr), cMemoryOwn);
    swigCPtr = cPtr;
  }

  protected static long getCPtr(Module obj) {
    return (obj == null) ? 0 : obj.swigCPtr;
  }

  protected void finalize() {
    delete();
  }

  public synchronized void delete() {
    if (swigCPtr != 0) {
      if (swigCMemOwn) {
        swigCMemOwn = false;
        dgmppJNI.delete_Module(swigCPtr);
      }
      swigCPtr = 0;
    }
    super.delete();
  }

  public static int getAnySocket() {
    return dgmppJNI.Module_anySocket_get();
  }

  public boolean canHaveState(Module.State state) {
    return dgmppJNI.Module_canHaveState(swigCPtr, this, state.swigValue());
  }

  public States availableStates() {
    return new States(dgmppJNI.Module_availableStates(swigCPtr, this), true);
  }

  public Module.State state() {
    return Module.State.swigToEnum(dgmppJNI.Module_state__SWIG_0(swigCPtr, this));
  }

  public Module.State preferredState() {
    return Module.State.swigToEnum(dgmppJNI.Module_preferredState(swigCPtr, this));
  }

  public void state(Module.State state) {
    dgmppJNI.Module_state__SWIG_1(swigCPtr, this, state.swigValue());
  }

  public Ship target() {
    long cPtr = dgmppJNI.Module_target__SWIG_0(swigCPtr, this);
    return (cPtr == 0) ? null : new Ship(cPtr, false);
  }

  public void target(Ship target) {
    dgmppJNI.Module_target__SWIG_1(swigCPtr, this, Ship.getCPtr(target), target);
  }

  public Module.Slot slot() {
    return Module.Slot.swigToEnum(dgmppJNI.Module_slot(swigCPtr, this));
  }

  public Module.Hardpoint hardpoint() {
    return Module.Hardpoint.swigToEnum(dgmppJNI.Module_hardpoint(swigCPtr, this));
  }

  public int socket() {
    return dgmppJNI.Module_socket(swigCPtr, this);
  }

  public Charge charge() {
    long cPtr = dgmppJNI.Module_charge__SWIG_0(swigCPtr, this);
    return (cPtr == 0) ? null : new Charge(cPtr, false);
  }

  public Charge charge(TypeID typeID) {
    long cPtr = dgmppJNI.Module_charge__SWIG_1(swigCPtr, this, typeID.swigValue());
    return (cPtr == 0) ? null : new Charge(cPtr, false);
  }

  public boolean canFit(Charge charge) {
    return dgmppJNI.Module_canFit(swigCPtr, this, Charge.getCPtr(charge), charge);
  }

  public GroupIDs chargeGroups() {
    return new GroupIDs(dgmppJNI.Module_chargeGroups(swigCPtr, this), false);
  }

  public Charge.Size chargeSize() {
    return Charge.Size.swigToEnum(dgmppJNI.Module_chargeSize(swigCPtr, this));
  }

  public boolean canBeOnline() {
    return dgmppJNI.Module_canBeOnline(swigCPtr, this);
  }

  public boolean canBeActive() {
    return dgmppJNI.Module_canBeActive(swigCPtr, this);
  }

  public boolean canBeOverloaded() {
    return dgmppJNI.Module_canBeOverloaded(swigCPtr, this);
  }

  public boolean requireTarget() {
    return dgmppJNI.Module_requireTarget(swigCPtr, this);
  }

  public boolean fail() {
    return dgmppJNI.Module_fail(swigCPtr, this);
  }

  public boolean factorReload() {
    return dgmppJNI.Module_factorReload__SWIG_0(swigCPtr, this);
  }

  public void factorReload(boolean factorReload) {
    dgmppJNI.Module_factorReload__SWIG_1(swigCPtr, this, factorReload);
  }

  public long charges() {
    return dgmppJNI.Module_charges(swigCPtr, this);
  }

  public long shots() {
    return dgmppJNI.Module_shots(swigCPtr, this);
  }

  public UnitsPerSecond capUse() {
    return new UnitsPerSecond(dgmppJNI.Module_capUse(swigCPtr, this), true);
  }

  public double cpuUse() {
    return dgmppJNI.Module_cpuUse(swigCPtr, this);
  }

  public double powerGridUse() {
    return dgmppJNI.Module_powerGridUse(swigCPtr, this);
  }

  public double calibrationUse() {
    return dgmppJNI.Module_calibrationUse(swigCPtr, this);
  }

  public double accuracyScore() {
    return dgmppJNI.Module_accuracyScore(swigCPtr, this);
  }

  public double signatureResolution() {
    return dgmppJNI.Module_signatureResolution(swigCPtr, this);
  }

  public UnitsPerSecond miningYield() {
    return new UnitsPerSecond(dgmppJNI.Module_miningYield(swigCPtr, this), true);
  }

  public DamageVector volley() {
    return new DamageVector(dgmppJNI.Module_volley(swigCPtr, this), true);
  }

  public DamagePerSecond dps() {
    return new DamagePerSecond(dgmppJNI.Module_dps(swigCPtr, this), true);
  }

  public double optimal() {
    return dgmppJNI.Module_optimal(swigCPtr, this);
  }

  public double falloff() {
    return dgmppJNI.Module_falloff(swigCPtr, this);
  }

  public double reloadTime() {
    return dgmppJNI.Module_reloadTime(swigCPtr, this);
  }

  public double cycleTime() {
    return dgmppJNI.Module_cycleTime(swigCPtr, this);
  }

  public double rawCycleTime() {
    return dgmppJNI.Module_rawCycleTime(swigCPtr, this);
  }

  public double lifeTime() {
    return dgmppJNI.Module_lifeTime(swigCPtr, this);
  }

  public final static class State {
    public final static Module.State unknown = new Module.State("unknown", dgmppJNI.Module_State_unknown_get());
    public final static Module.State offline = new Module.State("offline");
    public final static Module.State online = new Module.State("online");
    public final static Module.State active = new Module.State("active");
    public final static Module.State overloaded = new Module.State("overloaded");

    public final int swigValue() {
      return swigValue;
    }

    public String toString() {
      return swigName;
    }

    public static State swigToEnum(int swigValue) {
      if (swigValue < swigValues.length && swigValue >= 0 && swigValues[swigValue].swigValue == swigValue)
        return swigValues[swigValue];
      for (int i = 0; i < swigValues.length; i++)
        if (swigValues[i].swigValue == swigValue)
          return swigValues[i];
      throw new IllegalArgumentException("No enum " + State.class + " with value " + swigValue);
    }

    private State(String swigName) {
      this.swigName = swigName;
      this.swigValue = swigNext++;
    }

    private State(String swigName, int swigValue) {
      this.swigName = swigName;
      this.swigValue = swigValue;
      swigNext = swigValue+1;
    }

    private State(String swigName, State swigEnum) {
      this.swigName = swigName;
      this.swigValue = swigEnum.swigValue;
      swigNext = this.swigValue+1;
    }

    private static State[] swigValues = { unknown, offline, online, active, overloaded };
    private static int swigNext = 0;
    private final int swigValue;
    private final String swigName;
  }

  public final static class Slot {
    public final static Module.Slot none = new Module.Slot("none");
    public final static Module.Slot hi = new Module.Slot("hi");
    public final static Module.Slot med = new Module.Slot("med");
    public final static Module.Slot low = new Module.Slot("low");
    public final static Module.Slot rig = new Module.Slot("rig");
    public final static Module.Slot subsystem = new Module.Slot("subsystem");
    public final static Module.Slot mode = new Module.Slot("mode");
    public final static Module.Slot service = new Module.Slot("service");
    public final static Module.Slot starbaseStructure = new Module.Slot("starbaseStructure");

    public final int swigValue() {
      return swigValue;
    }

    public String toString() {
      return swigName;
    }

    public static Slot swigToEnum(int swigValue) {
      if (swigValue < swigValues.length && swigValue >= 0 && swigValues[swigValue].swigValue == swigValue)
        return swigValues[swigValue];
      for (int i = 0; i < swigValues.length; i++)
        if (swigValues[i].swigValue == swigValue)
          return swigValues[i];
      throw new IllegalArgumentException("No enum " + Slot.class + " with value " + swigValue);
    }

    private Slot(String swigName) {
      this.swigName = swigName;
      this.swigValue = swigNext++;
    }

    private Slot(String swigName, int swigValue) {
      this.swigName = swigName;
      this.swigValue = swigValue;
      swigNext = swigValue+1;
    }

    private Slot(String swigName, Slot swigEnum) {
      this.swigName = swigName;
      this.swigValue = swigEnum.swigValue;
      swigNext = this.swigValue+1;
    }

    private static Slot[] swigValues = { none, hi, med, low, rig, subsystem, mode, service, starbaseStructure };
    private static int swigNext = 0;
    private final int swigValue;
    private final String swigName;
  }

  public final static class Hardpoint {
    public final static Module.Hardpoint none = new Module.Hardpoint("none");
    public final static Module.Hardpoint launcher = new Module.Hardpoint("launcher");
    public final static Module.Hardpoint turret = new Module.Hardpoint("turret");

    public final int swigValue() {
      return swigValue;
    }

    public String toString() {
      return swigName;
    }

    public static Hardpoint swigToEnum(int swigValue) {
      if (swigValue < swigValues.length && swigValue >= 0 && swigValues[swigValue].swigValue == swigValue)
        return swigValues[swigValue];
      for (int i = 0; i < swigValues.length; i++)
        if (swigValues[i].swigValue == swigValue)
          return swigValues[i];
      throw new IllegalArgumentException("No enum " + Hardpoint.class + " with value " + swigValue);
    }

    private Hardpoint(String swigName) {
      this.swigName = swigName;
      this.swigValue = swigNext++;
    }

    private Hardpoint(String swigName, int swigValue) {
      this.swigName = swigName;
      this.swigValue = swigValue;
      swigNext = swigValue+1;
    }

    private Hardpoint(String swigName, Hardpoint swigEnum) {
      this.swigName = swigName;
      this.swigValue = swigEnum.swigValue;
      swigNext = this.swigValue+1;
    }

    private static Hardpoint[] swigValues = { none, launcher, turret };
    private static int swigNext = 0;
    private final int swigValue;
    private final String swigName;
  }

}
