use candid::{CandidType, Decode, Deserialize, Encode};
use ic_stable_structures::{
    memory_manager::{MemoryId, MemoryManager},
    writer::Writer,
    DefaultMemoryImpl, Memory,
};
use std::cell::RefCell;

pub struct Random {
    pub state: u64,
    pub size: Option<u32>,
    pub ind: u32,
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
#[cfg(target_family = "wasm")]
pub fn get_mem() -> (u128, u128, u128) {
    let size = core::arch::wasm32::memory_size(0) as u128 * 65536;
    (size, size, size)
}
#[cfg(not(target_family = "wasm"))]
pub fn get_mem() -> (u128, u128, u128) {
    unimplemented!()
}

thread_local! {
    static MEMORY_MANAGER: RefCell<MemoryManager<DefaultMemoryImpl>> =
        RefCell::new(MemoryManager::init(DefaultMemoryImpl::default()));
}

const PROFILING: MemoryId = MemoryId::new(100);
const UPGRADES: MemoryId = MemoryId::new(0);

pub fn profiling_init() {
    let memory = MEMORY_MANAGER.with(|m| m.borrow().get(PROFILING));
    memory.grow(32);
}

pub fn save_stable<T: CandidType>(val: &T) {
    let bytes = Encode!(val).unwrap();
    let len = bytes.len() as u32;
    let mut memory = MEMORY_MANAGER.with(|m| m.borrow().get(UPGRADES));
    let mut writer = Writer::new(&mut memory, 0);
    writer.write(&len.to_le_bytes()).unwrap();
    writer.write(&bytes).unwrap();
}
pub fn restore_stable<T: CandidType + for<'a> Deserialize<'a>>() -> T {
    let memory = MEMORY_MANAGER.with(|m| m.borrow().get(UPGRADES));
    let mut len_bytes = [0; 4];
    memory.read(0, &mut len_bytes);
    let len = u32::from_le_bytes(len_bytes) as usize;
    let mut bytes = vec![0; len];
    memory.read(4, &mut bytes);
    Decode!(&bytes, T).unwrap()
}
