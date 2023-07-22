import HashMap "mo:base/HashMap";
import Nat32 "mo:base/Nat32";
import { hashNat8 } "mo:base/Hash";
import Iter "mo:base/Iter";
import Option "mo:base/Option";
import Random "random";

actor {
    func hash(x: Nat32) : Nat32 = hashNat8([x & (255 << 0),
       x & (255 << 8),
       x & (255 << 16),
       x & (255 << 24)
    ]);
    var map = HashMap.HashMap<Nat32, Nat32>(0, Nat32.equal, hash);
    let rand = Random.new(null, 42);

    stable var stable_map : [(Nat32, Nat32)] = [];

    system func preupgrade() {
        stable_map := Iter.toArray(map.entries());
    };
    system func postupgrade() {
        map := HashMap.fromIter(stable_map.vals(), 50_000, Nat32.equal, hash);
    };

    public func generate(size: Nat32) : async () {
        let rand = Random.new(?size, 1);
        let iter = Iter.map<Nat32, (Nat32, Nat32)>(rand, func x = (x, x));
        map := HashMap.fromIter(iter, Nat32.toNat size, Nat32.equal, hash);
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
