use ic_cdk::{update, timer};
use std::time::Duration;

#[update]
fn setTimer(sec: u64) {
    timer::set_timer(Duration::from_secs(sec), || {});
}

#[update]
fn cancelTimer(id: timer::TimerId) {
    timer::clear_timer(id);
}
