use candid::{CandidType, Decode, Deserialize, Encode};
use ic_stable_structures::{
    memory_manager::{MemoryId, MemoryManager},
    writer::Writer,
    DefaultMemoryImpl, Memory,
};
use std::cell::RefCell;
use std::cmp::Reverse;
use std::collections::BinaryHeap;

struct Random {
    state: u64,
    size: Option<u32>,
    ind: u32,
}
impl Random {
    pub fn new(size: Option<u32>, seed: u64) -> Self {
        Random {
            state: seed,
            size,
            ind: 0,
        }
    }
}
impl Iterator for Random {
    type Item = u64;
    fn next(&mut self) -> Option<Self::Item> {
        if let Some(size) = self.size {
            self.ind += 1;
            if self.ind > size {
                return None;
            }
        }
        self.state = self.state * 48271 % 0x7fffffff;
        Some(self.state)
    }
}

// TODO: remove this after we impl Reverse in Candid
#[derive(Deserialize, Eq, Ord, PartialEq, PartialOrd)]
struct RevU64(Reverse<u64>);
impl CandidType for RevU64 {
    fn _ty() -> candid::types::Type {
        u64::ty()
    }
    fn idl_serialize<S: candid::types::Serializer>(&self, serializer: S) -> Result<(), S::Error> {
        serializer.serialize_nat64(self.0 .0)
    }
}
impl From<u64> for RevU64 {
    fn from(v: u64) -> Self {
        Self(Reverse(v))
    }
}

thread_local! {
    static MAP: RefCell<BinaryHeap<RevU64>> = RefCell::default();
    static RAND: RefCell<Random> = RefCell::new(Random::new(None, 42));
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
    let value = Decode!(&bytes, BinaryHeap<RevU64>).unwrap();
    MAP.with(|cell| *cell.borrow_mut() = value);
}

#[ic_cdk::update]
fn generate(size: u32) {
    let rand = Random::new(Some(size), 1);
    let iter = rand.map(|x| x.into());
    MAP.with(|map| {
        let mut map = map.borrow_mut();
        *map = iter.collect::<BinaryHeap<RevU64>>();
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
                map.push(k.into());
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
