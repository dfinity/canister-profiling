import Splay "mo:splay";
import Nat32 "mo:base/Nat32";
import Iter "mo:base/Iter";
import Option "mo:base/Option";
import Random "random";
import O "mo:base/Order";

actor {
    func compare(x: (Nat32, Text), y: (Nat32, Text)) : O.Order = Nat32.compare(x.0, y.0);
    var map = Splay.Splay<(Nat32, Text)>(compare);
    let rand = Random.new(null, 42);

    public func generate(size: Nat) : async () {
        let rand = Random.new(?size, 1);
        let iter = Iter.map<Nat32, (Nat32, Text)>(rand, func x = (x, debug_show x));
        for ((k,v) in iter) {
            map.insert((k, v));
        }
    };
    public func get(x : Nat32) : async Bool {
        map.find((x, ""))
    };
    public func put(k : Nat32, v : Text) : async () {
        map.insert((k, v));
    };
    public func remove(x : Nat32) : async () {
        map.remove((x, ""))
    };
    public query func get_mem() : async (Nat,Nat,Nat) {
        Random.get_memory()
    };    
    public func batch_get(n : Nat) : async () {
        for (_ in Iter.range(1, n)) {
            ignore map.find((Option.get<Nat32>(rand.next(), 0), ""));
        }
    };
    public func batch_put(n : Nat) : async () {
        for (_ in Iter.range(1, n)) {
            let k = Option.get<Nat32>(rand.next(), 0);
            map.insert((k, debug_show k));
        }
    };
    public func batch_remove(n : Nat) : async () {
        for (_ in Iter.range(1, n)) {
            map.remove((Option.get<Nat32>(rand.next(), 0), ""));
        }
    };
}
