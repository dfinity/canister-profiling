import Nat = "mo:base/Nat";
import Nat32 = "mo:base/Nat32";

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
    }
};
