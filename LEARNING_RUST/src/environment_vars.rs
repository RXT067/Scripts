// To work with environment variables on linux

use std::env;

pub fn run() {
    let key = "FOO";
    match env::var(key) {
        Ok(val) => println!("{}: {:?}", key, val),
        Err(e) => println!("couldn't interpret {}: {}", key, e),
    }
}
