use fxhash::FxHashMap;
use std::cell::RefCell;

struct Random {
    state: u32,
    size: Option<u32>,
    ind: u32,
}
impl Random {
    pub fn new(size: Option<u32>, seed: u32) -> Self {
        Random { state: seed, size, ind: 0 }
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

thread_local! {
    // FxHashMap uses the same std::collections::HashMap with a deterministic hasher
    static MAP: RefCell<FxHashMap<u32, String>> = RefCell::default();
    static RAND: RefCell<Random> = RefCell::new(Random::new(None, 42));
    static CORE: RefCell<Core> = RefCell::new(Core::new(Delim::new()));
}

#[ic_cdk_macros::query]
fn eval(prog: String) -> String {
    format!("{:?}", motoko::vm::eval(&prog))
}

#[ic_cdk_macros::update]
fn generate(size: u32) {
    let rand = Random::new(Some(size), 1);
    let iter = rand.map(|x| crate::vm::value::from((x, x.to_string())));
    CORE.with(|core| {
        let ptr = core.alloc_iter(iter);
        core.eval(format!("
          var map = prim \"hashMapNew\" ();
          for ((x, x_s) in {}) {
             prim \"hashMapPut\" (map, x, x_s)
          }", ptr));
    })
}

#[ic_cdk_macros::update]
fn get(x: u32) -> Option<String> {
    let v = CORE.with(|core| {
        core.eval(format!("prim \"hashMapGet\" (map, {})", x))
    });
    v.into()
}

#[ic_cdk_macros::update]
fn put(k: u32, v: String) {
    todo!()
}

#[ic_cdk_macros::update]
fn remove(x: u32) {
    todo!()
}

#[ic_cdk_macros::update]
fn batch_get(n: u32) {
    todo!()
}

#[ic_cdk_macros::update]
fn batch_put(n: u32) {
    todo!()
}

#[ic_cdk_macros::update]
fn batch_remove(n: u32) {
    todo!()
}
