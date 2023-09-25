import TrieMap "mo:base/TrieMap";
import Nat64 "mo:base/Nat64";
import Hash "mo:base/Hash";
import Iter "mo:base/Iter";
import Option "mo:base/Option";
import Random "random";
import Profiling "../../../Profiling";

actor {
    stable let profiling = Profiling.init(32);
    
    func hash(x: Nat64) : Nat32 = Hash.hash(Nat64.toNat x);
    var map = TrieMap.TrieMap<Nat64, Nat64>(Nat64.equal, hash);
    stable var stableMap : [(Nat64, Nat64)] = [];
    let rand = Random.new(null, 42);

    system func preupgrade() {
        stableMap := Iter.toArray(map.entries());
    };
    system func postupgrade() {
        map := TrieMap.fromEntries(stableMap.vals(), Nat64.equal, hash);
    };

    public func generate(size: Nat32) : async () {
        let rand = Random.new(?size, 1);
        let iter = Iter.map<Nat64, (Nat64, Nat64)>(rand, func x = (x, x));
        map := TrieMap.fromEntries(iter, Nat64.equal, hash);
    };
    public query func get_mem() : async (Nat,Nat,Nat) {
        Random.get_memory()
    };    
    public func batch_get(n : Nat) : async () {
        for (_ in Iter.range(1, n)) {
            ignore map.get(Option.get<Nat64>(rand.next(), 0));
        }
    };
    public func batch_put(n : Nat) : async () {
        for (_ in Iter.range(1, n)) {        
            let k = Option.get<Nat64>(rand.next(), 0);
            map.put(k, k);
        }
    };
    public func batch_remove(n : Nat) : async () {
        let rand = Random.new(null, 1);
        for (_ in Iter.range(1, n)) {
            ignore map.remove(Option.get<Nat64>(rand.next(), 0));
        }
    };
}
