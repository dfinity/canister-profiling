use std::cell::RefCell;
use std::cmp::Reverse;
use std::collections::BinaryHeap;
use utils::Random;

thread_local! {
    static MAP: RefCell<BinaryHeap<Reverse<u64>>> = RefCell::default();
    static RAND: RefCell<Random> = RefCell::new(Random::new(None, 42));
}

#[ic_cdk::init]
fn init() {
    utils::profiling_init();
}
#[ic_cdk::pre_upgrade]
fn pre_upgrade() {
    MAP.with(|map| utils::save_stable(&map));
}
#[ic_cdk::post_upgrade]
fn post_upgrade() {
    let value: BinaryHeap<Reverse<u64>> = utils::restore_stable();
    MAP.with(|cell| *cell.borrow_mut() = value);
}

#[ic_cdk::update]
fn generate(size: u32) {
    let rand = Random::new(Some(size), 1);
    let iter = rand.map(Reverse);
    MAP.with(|map| {
        let mut map = map.borrow_mut();
        *map = iter.collect::<BinaryHeap<Reverse<u64>>>();
    });
}

#[ic_cdk::query]
fn get_mem() -> (u128, u128, u128) {
    utils::get_mem()
}

#[ic_cdk::update]
fn batch_get(n: u32) {
    MAP.with(|map| {
        let mut map = map.borrow_mut();
        for _ in 0..n {
            map.pop();
        }
    })
}

#[ic_cdk::update]
fn batch_put(n: u32) {
    MAP.with(|map| {
        let mut map = map.borrow_mut();
        RAND.with(|rand| {
            let mut rand = rand.borrow_mut();
            for _ in 0..n {
                let k = rand.next().unwrap();
                map.push(Reverse(k));
            }
        })
    })
}

#[ic_cdk::update]
fn batch_remove(n: u32) {
    MAP.with(|map| {
        let mut map = map.borrow_mut();
        for _ in 0..n {
            map.pop();
        }
    })
}
