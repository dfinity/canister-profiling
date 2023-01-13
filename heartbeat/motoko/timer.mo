import Timer "mo:base/Timer";

actor {
  public func setTimer(sec : Nat) : async Nat {
    Timer.setTimer(#seconds sec, func () : async () {});
  };
  public func cancelTimer(id : Nat) : async () {
    Timer.cancelTimer(id);
  };
}

