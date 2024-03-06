import Timer "mo:base/Timer";

actor {
  public func setTimer(sec : Nat) : async Nat {
    Timer.setTimer<system>(#seconds sec, func () : async () {});
  };
  public func cancelTimer(id : Nat) : async () {
    Timer.cancelTimer(id);
  };
  public func no_op() : async () {};
}

