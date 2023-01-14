use ic_cdk::{timer, update};
use std::cell::RefCell;
use std::time::Duration;

thread_local! {
    static ID: RefCell<timer::TimerId> = RefCell::default();
}

#[update]
fn setTimer(sec: u64) {
    let tid = timer::set_timer(Duration::from_secs(sec), || {});
    ID.with(|id| {
        *id.borrow_mut() = tid;
    });
}

#[update]
fn cancelTimer() {
    ID.with(|id| {
        timer::clear_timer(*id.borrow());
    });
}
