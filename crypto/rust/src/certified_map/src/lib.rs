use ic_certified_map::RbTree;
use serde_bytes::ByteBuf;
use std::cell::{Cell, RefCell};

struct Random {
    state: u64,
}
impl Random {
    fn new(seed: u64) -> Self {
        Random { state: seed }
    }
}
impl Iterator for Random {
    type Item = u64;
    fn next(&mut self) -> Option<Self::Item> {
        self.state = self.state * 48271 % 0x7fffffff;
        Some(self.state)
    }
}
struct Word(Random);
impl Word {
    fn new(seed: u64) -> Self {
        Word(Random::new(seed))
    }
}
impl Iterator for Word {
    type Item = [u8; 7];
    fn next(&mut self) -> Option<Self::Item> {
        let mut res: Self::Item = [0; 7];
        for i in 0..7 {
            let x = self.0.next()?;
            let x = x % 57 + 65;
            res[i] = x as u8;
        }
        Some(res)
    }
}

thread_local! {
    static COUNTER: Cell<u8> = Cell::new(0);
    static TREE: RefCell<RbTree<Vec<u8>, Vec<u8>>> = RefCell::new(RbTree::new());
}

#[ic_cdk::update]
fn generate(size: u64) {
    let mut iter = Word::new(1);
    TREE.with(|tree| {
        let mut tree = tree.borrow_mut();
        for _ in 0..size as usize {
            let w: Vec<u8> = iter.next().unwrap().into();
            tree.insert(w.clone(), w);
        }
    })
}

#[ic_cdk::query]
fn get_mem() -> (u128, u128, u128) {
    let size = core::arch::wasm32::memory_size(0) as u128 * 32768;
    (size, size, size)
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
        tree.insert("counter".into(), vec![count]);
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
