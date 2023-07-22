import Map "mo:stableheapbtreemap/BTree";
import Nat32 "mo:base/Nat32";
import Iter "mo:base/Iter";
import Option "mo:base/Option";
import Random "random";

actor {
    stable var map = Map.init<Nat32, Text>(null);
    let rand = Random.new(null, 42);

    public func generate(size : Nat32) : async () {
        let rand = Random.new(?size, 1);
        let iter = Iter.map<Nat32, (Nat32, Text)>(rand, func x = (x, debug_show x));
        for ((k, v) in iter) {
            ignore Map.insert(map, Nat32.compare, k, v);
        };
    };
    public func get(x : Nat32) : async ?Text {
        Map.get(map, Nat32.compare, x);
    };
    public func put(k : Nat32, v : Text) : async () {
        ignore Map.insert(map, Nat32.compare, k, v);
    };
    public func remove(x : Nat32) : async ?Text {
        Map.delete(map, Nat32.compare, x);
    };
    public query func get_mem() : async (Nat, Nat, Nat) {
        Random.get_memory();
    };
    public func batch_get(n : Nat) : async () {
        for (_ in Iter.range(1, n)) {
            let x = Option.get<Nat32>(rand.next(), 0);
            ignore Map.get(map, Nat32.compare, x);
        };
    };
    public func batch_put(n : Nat) : async () {
        for (_ in Iter.range(1, n)) {
            let k = Option.get<Nat32>(rand.next(), 0);
            ignore Map.insert(map, Nat32.compare, k, debug_show k);
        };
    };
    public func batch_remove(n : Nat) : async () {
        for (_ in Iter.range(1, n)) {
            let x = Option.get<Nat32>(rand.next(), 0);
            ignore Map.delete(map, Nat32.compare, x);
        };
    };
};
