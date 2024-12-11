// This example demonstrates an example of a minting and transferring a token in Leo.
program simple_token.aleo {

    // The collection of tokens this is from
    struct TokenCollection {
        // Amount of editions in this Collection
        editions: u32,
        // Remaining total NFTs in this collection
        remaining: u64
    }

    // The `Token` record datatype.
    record Token {
        // The token owner.
        owner: address,
        // The token collection this belongs to.
        collection: TokenCollection,
        edition: u64,
    }

    mapping token_collections: u8 => TokenCollection;

    // keys: setting index
    // values: setting value
    mapping general_settings: u8 => u128;

    async transition initialize_connections() -> Future {
        return initialize_collections_func();
    }

    async function initialize_collections_func() {
        general_settings.set(0u8, 5u128); // Number of collections
        general_settings.set(1u8, 5u128); // Max number of editions per collection
        general_settings.set(1u8, 100u128); // Number of total NFTs that can be minted

        // Set Token Collections
        token_collections.set(0u8, TokenCollection { editions: 5u32, remaining: 50u64 });
        token_collections.set(1u8, TokenCollection { editions: 4u32, remaining: 40u64 });
        token_collections.set(2u8, TokenCollection { editions: 3u32, remaining: 30u64 });
        token_collections.set(3u8, TokenCollection { editions: 2u32, remaining: 20u64 });
        token_collections.set(4u8, TokenCollection { editions: 1u32, remaining: 10u64 });
    }

    // The `mint` function initializes a new record with the
    // specified number of tokens assigned to the specified receiver.
    async transition mint(owner: address, seed: u64) -> (Token, Future) {
        // return Token {
        //     owner: owner,
        //     amount: amount,
        // };
        let rand: u8 = ChaCha::rand_u8() % 5u8;
    }

    async function mint_func(owner: address, seed: u64) {
        let randomCollection: u128 = ChaCha::rand_u128() % 5u128;   
    }

    // The `transfer` function sends the specified number of tokens
    // to the receiver from the provided token record.
    transition transfer(token: Token, to: address, amount: u64) -> (Token, Token) {

        // Checks the given token record has sufficient balance.
        // This `sub` operation is safe, and the proof will fail
        // if an overflow occurs.
        // `difference` holds the change amount to be returned to sender.
        let difference: u64 = token.amount - amount;

        // Produce a token record with the change amount for the sender.
        let remaining: Token = Token {
            owner: token.owner,
            amount: difference,
        };

        // Produce a token record for the specified receiver.
        let transferred: Token = Token {
            owner: to,
            amount: amount,
        };

        // Output the sender's change record and the receiver's record.
        return (remaining, transferred);
    }
}
