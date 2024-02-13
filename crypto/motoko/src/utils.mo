import { tabulate } "mo:base/Array";
import { fromNat = Nat8fromNat } "mo:base/Nat8";
import { toNat; fromNat = Nat64fromNat } "mo:base/Nat64";
import { range } "mo:base/Iter";
import Prim "mo:⛔";

module {
    public func nat64_to_be(x : Nat64) : [Nat8] {
        tabulate<Nat8>(8, func i = x >> (Nat64fromNat (7-i) * 8) & 0xff |> toNat _ |> Nat8fromNat _);
    };
    public class Random(seed: Nat64) {
        var state : Nat64 = seed;
        public func gen() : Nat64 {
            state := state * 48271 % 0x7fffffff;
            state;
        }
    };
    public class Word(seed: Nat64) {
        let rand: Random = Random(seed);
        public func gen() : [Nat8] {
            tabulate<Nat8>(7, func i {
                let x = rand.gen() % 57 + 65;
                x |> toNat _ |> Nat8fromNat _
            })
        }
    };
    public func get_memory(): (Nat,Nat,Nat) {
        (Prim.rts_memory_size(), Prim.rts_heap_size(), Prim.rts_max_live_size())
    };
}
