import HashMap "mo:stable-hash-map";
import Nat32 "mo:base/Nat32";
import { hashNat8 } "mo:base/Hash";
import Iter "mo:base/Iter";
import Option "mo:base/Option";
import Random "random";

actor {
    func f_hash(x : Nat32) : Nat32 = hashNat8([
        x & (255 << 0),
        x & (255 << 8),
        x & (255 << 16),
        x & (255 << 24),
    ]);
    let hash : HashMap.HashUtils<Nat32> = (f_hash, Nat32.equal, func() = 0);
    stable var map = HashMap.new<Nat32, Text>(hash);
    let rand = Random.new(null, 42);

    public func generate(size : Nat32) : async () {
        let rand = Random.new(?size, 1);
        let iter = Iter.map<Nat32, (Nat32, Text)>(rand, func x = (x, debug_show x));
        map := HashMap.fromIter(iter, hash);
    };
    public func get(x : Nat32) : async ?Text {
        HashMap.get(map, hash, x);
    };
    public func put(k : Nat32, v : Text) : async () {
        ignore HashMap.put(map, hash, k, v);
    };
    public func remove(x : Nat32) : async ?Text {
        HashMap.remove(map, hash, x);
    };
    public query func get_mem() : async (Nat, Nat, Nat) {
        Random.get_memory();
    };
    public func batch_get(n : Nat) : async () {
        for (_ in Iter.range(1, n)) {
            ignore HashMap.get(map, hash, Option.get<Nat32>(rand.next(), 0));
        };
    };
    public func batch_put(n : Nat) : async () {
        for (_ in Iter.range(1, n)) {
            let k = Option.get<Nat32>(rand.next(), 0);
            ignore HashMap.put(map, hash, k, debug_show k);
        };
    };
    public func batch_remove(n : Nat) : async () {
        for (_ in Iter.range(1, n)) {
            ignore HashMap.remove(map, hash, Option.get<Nat32>(rand.next(), 0));
        };
    };
};
