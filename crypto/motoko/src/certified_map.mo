import CertTree "mo:ic-certification/CertTree";
import Blob "mo:base/Blob";
import { tabulate } "mo:base/Array";

actor {
    var counter : Nat8 = 0;
    let cert_store : CertTree.Store = CertTree.newStore();
    let tree = CertTree.Ops(cert_store);

    func hash(x : Nat8) : [Nat8] = tabulate<Nat8>(32, func i = if (i==0) { x } else { 0 });
    
    public func inc() : async () {
        counter += 1;
        let val = Blob.fromArray(hash(counter));
        tree.put(["counter"], val);
    };
    public func witness() : async (Blob, Blob) {
        let root = tree.treeHash();
        let witness = tree.reveal(["counter"]);
        (root, tree.encodeWitness(witness))
    };
}
