import RBTree "mo:base/OrderedMap";
import Nat64 "mo:base/Nat64";
import Iter "mo:base/Iter";
import Option "mo:base/Option";
import Random "random";
import Profiling "../../../utils/motoko/Profiling";

actor {
    stable let profiling = Profiling.init();
    
    var Ops = RBTree.Make<Nat64>(Nat64.compare);
    stable var map : RBTree.Map<Nat64, Nat64> = Ops.empty<Nat64>();
    let rand = Random.new(null, 42);
    
    public func generate(size: Nat32) : async () {
        let rand = Random.new(?size, 1);
        let iter = Iter.map<Nat64, (Nat64, Nat64)>(rand, func x = (x, x));
        map := Ops.fromIter<Nat64>(iter);
    };
    public query func get_mem() : async (Nat,Nat,Nat) {
        Random.get_memory()
    };
    public func batch_get(n : Nat) : async () {
        for (_ in Iter.range(1, n)) {
            ignore Ops.get(map, Option.get<Nat64>(rand.next(), 0));
        }
    };
    public func batch_put(n : Nat) : async () {
        for (_ in Iter.range(1, n)) {
            let k = Option.get<Nat64>(rand.next(), 0);
            map := Ops.put(map, k, k);
        }
    };
    public func batch_remove(n : Nat) : async () {
        let rand = Random.new(null, 1);
        for (_ in Iter.range(1, n)) {
            map := Ops.remove(map, Option.get<Nat64>(rand.next(), 0)).0;
        }
    };
}
