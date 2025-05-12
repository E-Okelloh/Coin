
#[allow(unused_variable)]
module coin::coin {

    use sui::coin::{Self, Coin, TreasuryCap};

    /// Name of the coin. By convention, this type has the same name as its parent module
    /// and has no fields. The full type of the coin defined by this module will be COIN<COIN>.
    public struct COIN has drop {}

    /// Register the token currency to acquire its TreasuryCap. Because
    /// this is a module initializer, it ensures the currency only gets
    /// registered once.
    fun init(witness: COIN, ctx: &mut TxContext) {
        let (treasury_cap, metadata) = coin::create_currency<COIN>(
            witness,
            8, // Decimals
            b"COIN", // Name
            b"COIN", // Symbol
            b"COIN token on Sui blockchain", // Description
            option::none(), // Icon URL - optional
            ctx
        );
        
        transfer::public_freeze_object(metadata);
        transfer::public_transfer(treasury_cap, tx_context::sender(ctx))
    }

    /// Manager can mint new tokens
    public entry fun mint(
        treasury_cap: &mut TreasuryCap<COIN>, 
        amount: u64, 
        recipient: address, 
        ctx: &mut TxContext
    ) {
        coin::mint_and_transfer(treasury_cap, amount, recipient, ctx)
    }

    /// Manager can burn tokens
    public entry fun burn(
        treasury_cap: &mut TreasuryCap<COIN>, 
        coin: Coin<COIN>
    ) {
        coin::burn(treasury_cap, coin);
    }

    /// Allow users to transfer coins
    public entry fun transfer(
        coin: Coin<COIN>, 
        recipient: address,
        ctx: &mut TxContext
    ) {
        transfer::public_transfer(coin, recipient)
    }

    #[test_only]
    /// Wrapper of module initializer for testing
    public fun test_init(_ctx: &mut TxContext) {
        init(COIN {}, _ctx)
    }
}


// For Move coding conventions, see
// https://docs.sui.io/concepts/sui-move-concepts/conventions


