import { tabulate } "mo:base/Array";
import { fromNat = Nat8fromNat } "mo:base/Nat8";
import { toNat; fromNat = Nat64fromNat } "mo:base/Nat64";

module {
    public func nat64_to_be(x : Nat64) : [Nat8] {
        tabulate<Nat8>(8, func i = x >> (Nat64fromNat (7-i) * 8) & 0xff |> toNat _ |> Nat8fromNat _);
    };
}
