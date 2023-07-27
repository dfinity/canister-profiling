use ic_certified_map::{leaf_hash, Hash, RbTree};
use serde_bytes::ByteBuf;
use std::cell::{Cell, RefCell};

thread_local! {
    static COUNTER: Cell<u64> = Cell::new(0);
    static TREE: RefCell<RbTree<&'static str, Hash>> = RefCell::new(RbTree::new());
}

#[ic_cdk::update]
fn inc() {
    let count = COUNTER.with(|counter| {
        let count = counter.get() + 1;
        counter.set(count);
        count
    });
    TREE.with(|tree| {
        let mut tree = tree.borrow_mut();
        tree.insert("counter", leaf_hash(&count.to_be_bytes()));
    })
}

#[ic_cdk::update]
fn witness() -> (ByteBuf, ByteBuf) {
    use ic_certified_map::AsHashTree;
    use serde::ser::Serialize;
    TREE.with(|tree| {
        let tree = tree.borrow();
        let root = tree.root_hash();
        let mut witness = vec![];
        let mut witness_serializer = serde_cbor::Serializer::new(&mut witness);
        witness_serializer.self_describe().unwrap();
        tree.witness(b"counter")
            .serialize(&mut witness_serializer)
            .unwrap();
        (ByteBuf::from(root), ByteBuf::from(witness))
    })
}
