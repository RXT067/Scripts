// Primitive str = Immutable fixed-lenght strings somewhere in memory
// String == Growable, heap-allocated data structire - Use when you need to modify or own string data

pub fn run() {
    let mut hello = String::from("Hello ");

    // Get lenght of output
    println!("Lenght: {}", hello.len());

    hello.push('W');
    // Push W in hello variable
    // Chars only

    hello.push_str("orld!");
    // To push string in hello variable

    // Capacity in bytes
    println!("Capacity: {}", hello.capacity());

    // Check if empty
    println!("Is Empty: {}", hello.is_empty());

    // Check if contains 'World'
    println!("Contains 'World' {}", hello.contains("World"));

    // Replace 'World' with 'There'
    println!("Replace: {}", hello.replace("World", "There"));

    // Loop through string by whitespace
    for word in hello.split_whitespace() {
        println!("{}", word);
    }

    // Create string with capacity
    let mut s = String::with_capacity(10);
    s.push('a');
    s.push('b');

    // Assertion testing
    // / Fails if Left (first var) is not equal right (second var)
    assert_eq!(2, s.len());
    assert_eq!(11, s.capacity());

    println!("{}",s);

    println!("{}", hello);
}