import Nat64 "mo:base/Nat64";
import Iter "mo:base/Iter";
import Option "mo:base/Option";
import Region "mo:base/Region";

import Random "random";
import Profiling "../../../utils/motoko/Profiling";

import BytesConverter "mo:StableBTree/modules/bytesConverter";
import Map "mo:StableBTree/modules/btreemap";
import Memory "mo:StableBTree/modules/memory";

actor {
    stable let profiling = Profiling.init();
    stable var region = Region.new();
    let n64conv = BytesConverter.n64conv;
    var map = Map.init<Nat64, Nat64>(
      Memory.RegionMemory(region),
      n64conv,
      n64conv
    );

    let rand = Random.new(null, 42);

    public func generate(size : Nat32) : async () {
        let rand = Random.new(?size, 1);
        let iter = Iter.map<Nat64, (Nat64, Nat64)>(rand, func x = (x, x));
        for ((k, v) in iter) {
            ignore map.insert(k, n64conv, v, n64conv);
        };
    };
    public query func get_mem() : async (Nat, Nat, Nat) {
        let size = Nat64.toNat(Region.size(region)) * 65536;
        (size, size, size)
    };
    public func batch_get(n : Nat) : async () {
        for (_ in Iter.range(1, n)) {
            let x = Option.get<Nat64>(rand.next(), 0);
            ignore map.get(x, n64conv, n64conv);
        };
    };
    public func batch_put(n : Nat) : async () {
        for (_ in Iter.range(1, n)) {
            let k = Option.get<Nat64>(rand.next(), 0);
            ignore map.insert(k, n64conv, k, n64conv);
        };
    };
    public func batch_remove(n : Nat) : async () {
        let rand = Random.new(null, 1);
        for (_ in Iter.range(1, n)) {
            let x = Option.get<Nat64>(rand.next(), 0);
            ignore map.remove(x, n64conv, n64conv);
        };
    };
};
