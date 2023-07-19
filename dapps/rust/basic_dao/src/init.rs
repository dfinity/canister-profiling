use crate::env::CanisterEnvironment;
use crate::service::BasicDaoService;
use crate::types::BasicDaoStableStorage;
use crate::SERVICE;
use ic_cdk::init;

#[init]
fn init(init_state: BasicDaoStableStorage) {
    ic_cdk::setup();

    let mut init_service = BasicDaoService::from(init_state);
    init_service.env = Box::new(CanisterEnvironment {});

    SERVICE.with(|service| *service.borrow_mut() = init_service);
}
