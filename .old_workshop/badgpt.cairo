

#[starknet::contract]
mod ERC20 {
    use starknet::{get_caller_address, ContractAddress};

    #[storage]
    struct Storage {
        total_tokens: u128,
        balances: LegacyMap<ContractAddress, u128>,
        allowances: LegacyMap<ContractAddress, LegacyMap<ContractAddress, u128>>,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        Transfer: TransferEvent,
        Approval: ApprovalEvent,
    }

    #[derive(Drop, starknet::Event)]
    struct TransferEvent {
        #[key]
        from: ContractAddress,
        #[key]
        to: ContractAddress,
        value: u128,
    }

    #[derive(Drop, starknet::Event)]
    struct ApprovalEvent {
        #[key]
        owner: ContractAddress,
        #[key]
        spender: ContractAddress,
        value: u128,
    }

    #[constructor]
    fn constructor(ref self: ContractState, initial_supply: u128) {
        self.total_tokens.write(initial_supply);
        self.balances.write(get_caller_address(), initial_supply);
    }

    #[generate_trait]
    #[external(v0)]
    impl ERC20 of IERC20 {
        fn total_supply(self: @ContractState) -> u128 {
            self.total_tokens.read()
        }

        fn balance_of(self: @ContractState, owner: ContractAddress) -> u128 {
            self.balances.read(owner)
        }

        fn transfer(ref self: ContractState, to: ContractAddress, value: u128) -> bool {
            let sender = get_caller_address();
            let sender_balance = self.balances.read(sender);
            if sender_balance < value {
                return false;
            }

            self.balances.write(sender, sender_balance - value);
            let recipient_balance = self.balances.read(to);
            self.balances.write(to, recipient_balance + value);

            self.emit(Event::Transfer(TransferEvent { from: sender, to: to, value: value }));
            true
        }

        fn approve(ref self: ContractState, spender: ContractAddress, value: u128) -> bool {
            let owner = get_caller_address();
            self.allowances[owner].write(spender, value);
            self.emit(Event::Approval(ApprovalEvent { owner: owner, spender: spender, value: value }));
            true
        }

        fn allowance(self: @ContractState, owner: ContractAddress, spender: ContractAddress) -> u128 {
            self.allowances[owner].read(spender)
        }

        fn transfer_from(ref self: ContractState, from: ContractAddress, to: ContractAddress, value: u128) -> bool {
            let sender = get_caller_address();
            let allowance = self.allowance(from, sender);
            let from_balance = self.balance_of(from);

            if allowance < value || from_balance < value {
                return false;
            }

            self.allowances[from].write(sender, allowance - value);
            self.balances.write(from, from_balance - value);
            let recipient_balance = self.balances.read(to);
            self.balances.write(to, recipient_balance + value);

            self.emit(Event::Transfer(TransferEvent { from: from, to: to, value: value }));
            true
        }
    }

    // Additional internal functions if needed can be added in a similar manner to the provided example.
}

