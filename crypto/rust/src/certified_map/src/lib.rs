use ic_certified_map::RbTree;
use serde_bytes::{ByteBuf, Bytes};
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
        for item in &mut res {
            let x = self.0.next()?;
            let x = x % 57 + 65;
            *item = x as u8;
        }
        Some(res)
    }
}

thread_local! {
    static COUNTER: Cell<u8> = Cell::new(0);
    static TREE: RefCell<RbTree<Vec<u8>, Vec<u8>>> = RefCell::new(RbTree::new());
}

#[ic_cdk::init]
fn init() {
    utils::profiling_init();
}
#[ic_cdk::pre_upgrade]
fn pre_upgrade() {
    TREE.with(|tree| {
        let tree = tree.borrow();
        let vec: Vec<(&Bytes, &Bytes)> = tree
            .iter()
            .map(|(a, b)| (Bytes::new(a), Bytes::new(b)))
            .collect();
        utils::save_stable(&vec)
    });
}
#[ic_cdk::post_upgrade]
fn post_upgrade() {
    let value: Vec<(ByteBuf, ByteBuf)> = utils::restore_stable();
    TREE.with(|cell| {
        *cell.borrow_mut() = value
            .into_iter()
            .map(|(a, b)| (a.into_vec(), b.into_vec()))
            .collect()
    });
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
    utils::get_mem()
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
