// NAME      : Rustified Krey's Universal Linux Updater Scripts (RKULUS)
// Author    : github.com/kreyren
// Licence   : GNUv2 (https://www.gnu.org/licenses/old-licenses/gpl-2.0.cs.html)
// Abstract  : Rewrite KULUS (https://github.com/RXT067/Scripts/tree/master/KULUS) in rust so that i can learn it.
// Reasoning : Using KULUS function since is seems as the most effective way to perform for learn project.

// Problems
/// Won't Compile
//// error: failed to parse manifest at `/home/kreyren/Scripts/RKULUS/Cargo.toml`
//// 
//// Caused by:
////   no targets specified in the manifest
////   either src/lib.rs, src/main.rs, a [lib] section, or [[bin]] section must be present

// Notes
/// rustc <program> to compile

// References 
/// Video Sources
//// Source https://youtu.be/U1EFgCNLDB8
//// Source https://www.youtube.com/watch?v=KLMtnA2mGKs
/// Linux Variables in Rust
//// https://doc.rust-lang.org/std/env/index.html

// Imports

use std::path::Path;
/// Check if path exists
//// https://stackoverflow.com/questions/32384594/how-to-check-whether-a-path-exists

use std::process:Command; 
/// To invoke commands
//// https://doc.rust-lang.org/std/process/struct.Command.html

use std::env 
/// To greb environment variables
//// https://doc.rust-lang.org/std/env/index.html

// Variables

let something == not_nothing;
/// Self-made example

// TODO: Check what system it's invoked on and what package managers are present

println!("testvar {}", something); // Expected to output 'not_nothing'.
// Self-made example of output

fn update_gentoo() {
 // Abstract: if gentoo invoke emerge -uDU @world
	if(Path::new("/etc/portage").exists()){
 		Command::new("sh")
 			.arg("-c") // Mandatory?
 			println!("Updating Gentoo..");
 			//.arg("emerge -uDU @world") // Expected to update system.
 			.arg("emerge -uDUp @world") // Using -p which will pretend and won't write changes for test.
 			.output() // wut?
 			.expect("FATAL: Failed to execute process..")
 	} else {
 		println!("FATAL: Gentoo statement is not true..");
 	};
}


