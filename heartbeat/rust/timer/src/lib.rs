#![allow(non_snake_case)]

use ic_cdk::update;
use ic_cdk_timers::{clear_timer, set_timer, TimerId};
use std::cell::RefCell;
use std::time::Duration;

thread_local! {
    static ID: RefCell<TimerId> = RefCell::default();
}

#[update]
fn setTimer(sec: u64) {
    let tid = set_timer(Duration::from_secs(sec), || {});
    ID.with(|id| {
        *id.borrow_mut() = tid;
    });
}

#[update]
fn cancelTimer() {
    ID.with(|id| {
        clear_timer(*id.borrow());
    });
}

#[update]
fn no_op() {}
