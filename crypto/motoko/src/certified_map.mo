import CertTree "mo:ic-certification/CertTree";
import Blob "mo:base/Blob";
import Utils "utils";

actor {
    var counter : Nat64 = 0;
    let cert_store : CertTree.Store = CertTree.newStore();
    let tree = CertTree.Ops(cert_store);
    
    public func inc() : async () {
        counter += 1;
        let val = Blob.fromArray(Utils.nat64_to_be(counter));
        tree.put(["counter"], val);
    };
    public func witness() : async (Blob, Blob) {
        let root = tree.treeHash();
        let witness = tree.reveal(["counter"]);
        (root, tree.encodeWitness(witness))
    };
}
