import Map "mo:stableheapbtreemap/BTree";
import Nat64 "mo:base/Nat64";
import Iter "mo:base/Iter";
import Option "mo:base/Option";
import Random "random";
import Profiling "../../../utils/motoko/Profiling";

actor {
    stable let profiling = Profiling.init();
    
    stable var map = Map.init<Nat64, Nat64>(null);
    let rand = Random.new(null, 42);

    public func generate(size : Nat32) : async () {
        let rand = Random.new(?size, 1);
        let iter = Iter.map<Nat64, (Nat64, Nat64)>(rand, func x = (x, x));
        for ((k, v) in iter) {
            ignore Map.insert(map, Nat64.compare, k, v);
        };
    };
    public query func get_mem() : async (Nat, Nat, Nat) {
        Random.get_memory();
    };
    public func batch_get(n : Nat) : async () {
        for (_ in Iter.range(1, n)) {
            let x = Option.get<Nat64>(rand.next(), 0);
            ignore Map.get(map, Nat64.compare, x);
        };
    };
    public func batch_put(n : Nat) : async () {
        for (_ in Iter.range(1, n)) {
            let k = Option.get<Nat64>(rand.next(), 0);
            ignore Map.insert(map, Nat64.compare, k, k);
        };
    };
    public func batch_remove(n : Nat) : async () {
        let rand = Random.new(null, 1);
        for (_ in Iter.range(1, n)) {
            let x = Option.get<Nat64>(rand.next(), 0);
            ignore Map.delete(map, Nat64.compare, x);
        };
    };
};
