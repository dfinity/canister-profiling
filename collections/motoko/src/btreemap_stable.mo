import Nat64 "mo:base/Nat64";
import Iter "mo:base/Iter";
import Option "mo:base/Option";
import Region "mo:base/Region";

import Random "random";
import Profiling "../../../utils/motoko/Profiling";

import BytesConverter "mo:StableBTree/bytesConverter";
import Map "mo:StableBTree/btreemap";
import Memory "mo:StableBTree/memory";

actor {
    stable let profiling = Profiling.init();
    stable var region = Region.new();
    
    var map = Map.init<Nat64, Nat64>(
      Memory.RegionMemory(region),
      BytesConverter.NAT64_CONVERTER,
      BytesConverter.NAT64_CONVERTER,
    );
    
    let rand = Random.new(null, 42);

    public func generate(size : Nat32) : async () {
        let rand = Random.new(?size, 1);
        let iter = Iter.map<Nat64, (Nat64, Nat64)>(rand, func x = (x, x));
        for ((k, v) in iter) {
            ignore map.insert(k, v);
        };
    };
    public query func get_mem() : async (Nat, Nat, Nat) {
        Random.get_memory();
    };
    public func batch_get(n : Nat) : async () {
        for (_ in Iter.range(1, n)) {
            let x = Option.get<Nat64>(rand.next(), 0);
            ignore map.get(x);
        };
    };
    public func batch_put(n : Nat) : async () {
        for (_ in Iter.range(1, n)) {
            let k = Option.get<Nat64>(rand.next(), 0);
            ignore map.insert(k, k);
        };
    };
    public func batch_remove(n : Nat) : async () {
        let rand = Random.new(null, 1);
        for (_ in Iter.range(1, n)) {
            let x = Option.get<Nat64>(rand.next(), 0);
            ignore map.remove(x);
        };
    };
};
