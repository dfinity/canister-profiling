import Region "mo:base/Region";

module {
    public func init(size: Nat64) : Region.Region {
        let profiling = Region.new();
        ignore Region.grow(profiling, size);
        profiling;
    };
}
