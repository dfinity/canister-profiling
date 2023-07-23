import Splay "mo:splay";
import Nat64 "mo:base/Nat64";
import Iter "mo:base/Iter";
import Option "mo:base/Option";
import Random "random";
import O "mo:base/Order";

actor {
    func compare(x: (Nat64, Nat64), y: (Nat64, Nat64)) : O.Order = Nat64.compare(x.0, y.0);
    var map = Splay.Splay<(Nat64, Nat64)>(compare);
    let rand = Random.new(null, 42);
    
    public func generate(size: Nat32) : async () {
        let rand = Random.new(?size, 1);
        let iter = Iter.map<Nat64, (Nat64, Nat64)>(rand, func x = (x, x));
        for ((k,v) in iter) {
            map.insert((k, v));
        }
    };
    public query func get_mem() : async (Nat,Nat,Nat) {
        Random.get_memory()
    };    
    public func batch_get(n : Nat) : async () {
        for (_ in Iter.range(1, n)) {
            ignore map.find((Option.get<Nat64>(rand.next(), 0), 0));
        }
    };
    public func batch_put(n : Nat) : async () {
        for (_ in Iter.range(1, n)) {
            let k = Option.get<Nat64>(rand.next(), 0);
            map.insert((k, k));
        }
    };
    public func batch_remove(n : Nat) : async () {
        let rand = Random.new(null, 1);
        for (_ in Iter.range(1, n)) {
            map.remove((Option.get<Nat64>(rand.next(), 0), 0));
        }
    };
}
