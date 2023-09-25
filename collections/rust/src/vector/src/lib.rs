use candid::{Decode, Encode};
use ic_stable_structures::{
    memory_manager::{MemoryId, MemoryManager},
    writer::Writer,
    DefaultMemoryImpl, Memory,
};
use std::cell::RefCell;

thread_local! {
    static MAP: RefCell<Vec<u64>> = RefCell::default();
    static MEMORY_MANAGER: RefCell<MemoryManager<DefaultMemoryImpl>> =
        RefCell::new(MemoryManager::init(DefaultMemoryImpl::default()));
}

const PROFILING: MemoryId = MemoryId::new(100);
const UPGRADES: MemoryId = MemoryId::new(0);

#[ic_cdk::init]
fn init() {
    let memory = MEMORY_MANAGER.with(|m| m.borrow().get(PROFILING));
    memory.grow(32);
}
#[ic_cdk::pre_upgrade]
fn pre_upgrade() {
    let bytes = MAP.with(|map| Encode!(map).unwrap());
    let len = bytes.len() as u32;
    let mut memory = MEMORY_MANAGER.with(|m| m.borrow().get(UPGRADES));
    let mut writer = Writer::new(&mut memory, 0);
    writer.write(&len.to_le_bytes()).unwrap();
    writer.write(&bytes).unwrap();
}
#[ic_cdk::post_upgrade]
fn post_upgrade() {
    let memory = MEMORY_MANAGER.with(|m| m.borrow().get(UPGRADES));
    let mut len_bytes = [0; 4];
    memory.read(0, &mut len_bytes);
    let len = u32::from_le_bytes(len_bytes) as usize;
    let mut bytes = vec![0; len];
    memory.read(4, &mut bytes);
    let value = Decode!(&bytes, Vec<u64>).unwrap();
    MAP.with(|cell| *cell.borrow_mut() = value);
}

#[ic_cdk::update]
fn generate(size: u32) {
    MAP.with(|map| {
        let mut map = map.borrow_mut();
        map.clear();
        for _ in 0..size {
            map.push(42);
        }
    });
}

#[ic_cdk::query]
fn get_mem() -> (u128, u128, u128) {
    let size = core::arch::wasm32::memory_size(0) as u128 * 32768;
    (size, size, size)
}

#[ic_cdk::update]
fn batch_get(n: u32) {
    MAP.with(|map| {
        let map = map.borrow();
        for idx in 0..n {
            let _ = map.get(idx as usize);
        }
    })
}

#[ic_cdk::update]
fn batch_put(n: u32) {
    MAP.with(|map| {
        let mut map = map.borrow_mut();
        for _ in 0..n {
            map.push(42);
        }
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
