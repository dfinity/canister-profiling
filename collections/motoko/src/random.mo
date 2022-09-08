import Nat = "mo:base/Nat";
import Nat32 = "mo:base/Nat32";
import Prim "mo:⛔";

module {
    public class new(size: ?Nat, seed: Nat32) {
      let modulus = 0x7fffffff;
      var state : Nat32 = seed;
      var ind = 0;

      public func next() : ?Nat32 {
          switch size {
          case null ();
          case (?size) {
                   ind += 1;
                   if (ind > size) {
                       return null;
                   };
               };
          };
          state := Nat32.fromNat(Nat32.toNat(state) * 48271 % modulus);
          ?state;
      };
    };
    public func get_memory(): (Nat,Nat,Nat) {
        (Prim.rts_memory_size(), Prim.rts_heap_size(), Prim.rts_max_live_size())
    };
};
