/* ----------------------------------------------------------------------------
 * This file was automatically generated by SWIG (http://www.swig.org).
 * Version 3.0.12
 *
 * Do not make changes to this file unless you know what you are doing--modify
 * the SWIG interface file instead.
 * ----------------------------------------------------------------------------- */

package com.dgmpp.jdgmpp;

public class Boosters {
  private transient long swigCPtr;
  protected transient boolean swigCMemOwn;

  protected Boosters(long cPtr, boolean cMemoryOwn) {
    swigCMemOwn = cMemoryOwn;
    swigCPtr = cPtr;
  }

  protected static long getCPtr(Boosters obj) {
    return (obj == null) ? 0 : obj.swigCPtr;
  }

  protected void finalize() {
    delete();
  }

  public synchronized void delete() {
    if (swigCPtr != 0) {
      if (swigCMemOwn) {
        swigCMemOwn = false;
        dgmppJNI.delete_Boosters(swigCPtr);
      }
      swigCPtr = 0;
    }
  }

  public Boosters() {
    this(dgmppJNI.new_Boosters__SWIG_0(), true);
  }

  public Boosters(long n) {
    this(dgmppJNI.new_Boosters__SWIG_1(n), true);
  }

  public long size() {
    return dgmppJNI.Boosters_size(swigCPtr, this);
  }

  public long capacity() {
    return dgmppJNI.Boosters_capacity(swigCPtr, this);
  }

  public void reserve(long n) {
    dgmppJNI.Boosters_reserve(swigCPtr, this, n);
  }

  public boolean isEmpty() {
    return dgmppJNI.Boosters_isEmpty(swigCPtr, this);
  }

  public void clear() {
    dgmppJNI.Boosters_clear(swigCPtr, this);
  }

  public void add(Booster x) {
    dgmppJNI.Boosters_add(swigCPtr, this, Booster.getCPtr(x), x);
  }

  public Booster get(int i) {
    long cPtr = dgmppJNI.Boosters_get(swigCPtr, this, i);
    return (cPtr == 0) ? null : new Booster(cPtr, false);
  }

  public void set(int i, Booster val) {
    dgmppJNI.Boosters_set(swigCPtr, this, i, Booster.getCPtr(val), val);
  }

}
