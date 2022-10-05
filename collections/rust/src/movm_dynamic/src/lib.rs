//use candid::Nat;
//use fxhash::FxHashMap;
use motoko::{
    ast::{Literal, ToId},
    dynamic::Dynamic,
    shared::{FastClone, Share},
    value::{ToMotoko, Value, Value_},
    vm_types::{Core, Interruption, Limits},
};
use motoko_proc_macro::parse_static;
use std::cell::RefCell;

#[derive(Clone, Debug, Hash, Default)]
struct Random {
    state: u32,
    size: Option<u32>,
    ind: u32,
}
impl Random {
    pub fn new(size: Option<u32>, seed: u32) -> Self {
        Random {
            state: seed,
            size,
            ind: 0,
        }
    }
}
impl Iterator for Random {
    type Item = u32;
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
impl Dynamic for Random {
    fn call(&self, _inst: &Option<motoko::ast::Inst>, _args: Value_) -> motoko::dynamic::Result {
        Ok(self.next().to_motoko().unwrap().share())
    }
}

#[derive(Clone, Debug, Default)]
struct Map(std::collections::HashMap<Value_, Value_>);

impl std::hash::Hash for Map {
    fn hash<H: std::hash::Hasher>(&self, _state: &mut H) {
        unimplemented!()
    }
}

impl Dynamic for Map {
    fn get_index(&self, index: Value_) -> motoko::dynamic::Result {
        self.0
            .get(&index)
            .map(FastClone::fast_clone)
            .ok_or_else(|| Interruption::IndexOutOfBounds)
    }

    fn set_index(&mut self, key: Value_, value: Value_) -> motoko::dynamic::Result<()> {
        self.0.insert(key, value);
        Ok(())
    }

    fn call(&self, _inst: &Option<motoko::ast::Inst>, _args: Value_) -> motoko::dynamic::Result {
        
        Ok(Value::Unit.share())
    }
}

thread_local! {
    static CORE: RefCell<Core> = RefCell::new({
        let mut core = Core::empty();
        let ptr = core.alloc(Map::default().into_value().share());
        core.env.insert("map".to_id(), Value::Pointer(ptr).share()).unwrap();
        core
    });
}

#[ic_cdk_macros::update]
fn generate(size: u32) {
    CORE.with(|core| {
        let mut core = core.borrow_mut();
        core.continue_(&Limits::none()).unwrap();
        core.eval_open_block(
            vec![("rand", Random::new(Some(size), 1).into_value().share())],
            parse_static!(
                "
                for (x in { next = rand }) {
                    map[x] := prim \"natToText\" x;
                }
                "
            )
            .clone(),
        )
        .unwrap();
    })
}

#[ic_cdk_macros::update]
fn get(x: u32) -> Option<String> {
    let _r = CORE
        .with(|core| {
            let mut core = core.borrow_mut();
            core.continue_(&Limits::none()).unwrap();
            core.eval_open_block(
                vec![("x", x.to_motoko().unwrap().share())],
                parse_static!("map[x]").clone(),
            )
        })
        .unwrap();
    None
}

#[ic_cdk_macros::update]
fn put(k: u32, v: String) {
    CORE.with(|core| {
        let mut core = core.borrow_mut();
        core.continue_(&Limits::none()).unwrap();
        core.eval_open_block(
            vec![
                ("k", k.to_motoko().unwrap().share()),
                ("v", v.to_motoko().unwrap().share()),
            ],
            parse_static!("map[k] := v").clone(),
        )
    })
    .unwrap();
}

#[ic_cdk_macros::update]
fn remove(x: u32) {
    CORE.with(|core| {
        (core.borrow_mut()).continue_(&Limits::none()).unwrap();
        (core.borrow_mut()).eval_open_block(
            vec![("x", x.to_motoko().unwrap().share())],
            parse_static!(
                "map(x)"
            )
            .clone(),
        )
    })
    .unwrap();
}

#[ic_cdk_macros::update]
fn batch_get(n: u32) {
    CORE.with(|core| {
        (core.borrow_mut()).continue_(&Limits::none()).unwrap();
        (core.borrow_mut()).eval_open_block(
            vec![("size", val_from_u32(n))],
            parse_static!(
                "
                 let j = rands(size);
                 for (x in j) {
                   let _ = prim \"hashMapGet\" (map, x);
                 }"
            )
            .clone(),
        )
    })
    .unwrap();
}

#[ic_cdk_macros::update]
fn batch_put(n: u32) {
    CORE.with(|core| {
        (core.borrow_mut()).continue_(&Limits::none()).unwrap();
        (core.borrow_mut()).eval_open_block(
            vec![("size", val_from_u32(n))],
            parse_static!(
                "
                 let j = rands(size);
                 for (x in j) {
                   let s = prim \"natToText\" x;
                   let (m, _) = prim \"hashMapPut\" (map, x, s);
                   map := m;
                 }"
            )
            .clone(),
        )
    })
    .unwrap();
}

#[ic_cdk_macros::update]
fn batch_remove(n: u32) {
    CORE.with(|core| {
        (core.borrow_mut()).continue_(&Limits::none()).unwrap();
        (core.borrow_mut()).eval_open_block(
            vec![("size", val_from_u32(n))],
            parse_static!(
                "
                 let j = rands(size);
                 for (x in j) {
                   let (m, _) = prim \"hashMapRemove\" (map, x);
                   map := m;
                 }"
            )
            .clone(),
        )
    })
    .unwrap();
}
