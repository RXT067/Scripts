use std::env;

pub fn run() {
    let mut args = env::args(); // Accept arguments
    let command = args.nth(1); // Grab first argument
    let name = "Brad";
    let status = "100%";


    // println!("Command: {}", command);

    match command.as_ref().map(|s| s.as_str()) {
            Some("hello") => println!("Hi {}, how are you?", name),
            Some("status") => println!("Status is {}", status),
            Some("print_arguments") => {
                for argument in args {
                    println!("{}", argument);
                }
            }
            _ => println!("That is not a valid command"),
        }
}
