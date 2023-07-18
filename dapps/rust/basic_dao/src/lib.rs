mod env;
mod heartbeat;
mod init;
mod service;
mod types;

use crate::service::BasicDaoService;
use crate::types::*;
use ic_cdk::{query, update};
use std::cell::RefCell;

thread_local! {
    static SERVICE: RefCell<BasicDaoService> = RefCell::default();
}

#[query]
fn get_system_params() -> SystemParams {
    SERVICE.with(|service| service.borrow().system_params.clone())
}

#[update]
fn transfer(args: TransferArgs) -> Result<(), String> {
    SERVICE.with(|service| service.borrow_mut().transfer(args))
}

#[query]
fn account_balance() -> Tokens {
    SERVICE.with(|service| service.borrow().account_balance())
}

#[query]
fn list_accounts() -> Vec<Account> {
    SERVICE.with(|service| service.borrow().list_accounts())
}

#[update]
fn submit_proposal(proposal: ProposalPayload) -> Result<u64, String> {
    SERVICE.with(|service| service.borrow_mut().submit_proposal(proposal))
}

#[query]
fn get_proposal(proposal_id: u64) -> Option<Proposal> {
    SERVICE.with(|service| service.borrow().get_proposal(proposal_id))
}

#[query]
fn list_proposals() -> Vec<Proposal> {
    SERVICE.with(|service| service.borrow().list_proposals())
}

#[update]
fn vote(args: VoteArgs) -> Result<ProposalState, String> {
    SERVICE.with(|service| service.borrow_mut().vote(args))
}

#[update]
fn update_system_params(payload: UpdateSystemParamsPayload) {
    SERVICE.with(|service| service.borrow_mut().update_system_params(payload))
}
