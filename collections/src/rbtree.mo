import RBTree "mo:base/RBTree";
import Nat32 "mo:base/Nat32";
import Iter "mo:base/Iter";
import Option "mo:base/Option";
import Random "random";

actor {
    var map = RBTree.RBTree<Nat32, Text>(Nat32.compare);
    let rand = Random.new(null, 42);

    public func generate(size: Nat) : async () {
        let rand = Random.new(?size, 1);
        let iter = Iter.map<Nat32, (Nat32, Text)>(rand, func x = (x, debug_show x));
        for ((k,v) in iter) {
            map.put(k, v);
        }
    };
    public func get(x : Nat32) : async ?Text {
        map.get(x)
    };
    public func put(k : Nat32, v : Text) : async () {
        map.put(k, v);
    };
    public func remove(x : Nat32) : async ?Text {
        map.remove(x)
    };
    public func batch_get(n : Nat) : async () {
        for (_ in Iter.range(1, n)) {
            ignore map.get(Option.get<Nat32>(rand.next(), 0));
        }
    };
    public func batch_put(n : Nat) : async () {
        for (_ in Iter.range(1, n)) {
            let k = Option.get<Nat32>(rand.next(), 0);
            map.put(k, debug_show k);
        }
    };
    public func batch_remove(n : Nat) : async () {
        for (_ in Iter.range(1, n)) {
            ignore map.remove(Option.get<Nat32>(rand.next(), 0));
        }
    };
}
