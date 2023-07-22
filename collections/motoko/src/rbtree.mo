import RBTree "mo:base/RBTree";
import Nat32 "mo:base/Nat32";
import Iter "mo:base/Iter";
import Option "mo:base/Option";
import Random "random";

actor {
    var map = RBTree.RBTree<Nat32, Nat32>(Nat32.compare);
    let rand = Random.new(null, 42);

    stable var stable_map : RBTree.Tree<Nat32, Nat32> = #leaf;

    system func preupgrade() {
        stable_map := map.share();
    };
    system func postupgrade() {
        // unshare is missing, if it exists, it will be one assignment
    };
    
    public func generate(size: Nat32) : async () {
        let rand = Random.new(?size, 1);
        let iter = Iter.map<Nat32, (Nat32, Nat32)>(rand, func x = (x, x));
        for ((k,v) in iter) {
            map.put(k, v);
        }
    };
    public func get(x : Nat32) : async ?Nat32 {
        map.get(x)
    };
    public func put(k : Nat32, v : Nat32) : async () {
        map.put(k, v);
    };
    public func remove(x : Nat32) : async ?Nat32 {
        map.remove(x)
    };
    public query func get_mem() : async (Nat,Nat,Nat) {
        Random.get_memory()
    };    
    public func batch_get(n : Nat) : async () {
        for (_ in Iter.range(1, n)) {
            ignore map.get(Option.get<Nat32>(rand.next(), 0));
        }
    };
    public func batch_put(n : Nat) : async () {
        for (_ in Iter.range(1, n)) {
            let k = Option.get<Nat32>(rand.next(), 0);
            map.put(k, k);
        }
    };
    public func batch_remove(n : Nat) : async () {
        for (_ in Iter.range(1, n)) {
            ignore map.remove(Option.get<Nat32>(rand.next(), 0));
        }
    };
}
