import Region "mo:base/Region";

module {
    public func init() : Region.Region {
        let profiling = Region.new();
        ignore Region.grow(profiling, 4096);
        profiling;
    };
}
