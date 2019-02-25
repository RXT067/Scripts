/// NAME      : Rustified Krey's Universal Linux Updater Scripts (RKULUS)
/// Author    : github.com/kreyren
/// Licence   : GNUv2 (https://www.gnu.org/licenses/old-licenses/gpl-2.0.cs.html)
/// Abstract  : Rewrite KULUS (https://github.com/RXT067/Scripts/tree/master/KULUS) in rust so that i can learn it.
/// Reasoning : Using KULUS function since is seems as the most effective way to perform for learn project.
/// Disclaimer: Mind that this program is expected to be full of comments used for learning.

/// PROBLEMS
/// Won't Compile
/// ---
/// error: failed to parse manifest at `/home/kreyren/Scripts/RKULUS/Cargo.toml`
///  
/// Caused by:
///    no targets specified in the manifest
///    either src/lib.rs, src/main.rs, a [lib] section, or [[bin]] section must be present

/// NOTES
/// Compilation is done using `rustc`
/// `////` are seen as 'documentation comments'
/// `//` are used for comments
///
/// Generaly you want to avoid global variables -> Slow, difficult to use in a safe way.
/// - Slow
/// - Difficult to use in a safe way
/// - Don't scale with threads
/// - Can make debugging more difficult
/// - Can't be mutated (without tricks)
/// <kreyren> is `static` used to set global variable?
/// * 01 twitches
/// <01> kreyren: geeeenerally
/// <01> you want to avoid globals
/// <kreyren> 01: why?
/// <01> slow, difficult to use in a safe way
/// <01> don't scale with threads
/// <kreyren> i see, still need to know correct syntax (learning rust)
/// <01> and can make debugging more difficult
/// <01> oh. and you can't mutate them
/// <01> (without tricks)
/// <kreyren> noted
/// <01> eval: static MSG: &'static str = "hello world"; MSG
/// -eval/#rust-beginners- "hello world"
/// <01> it defines a static varaible named MSG with the type &'static str pointing to a string in data memory
/// <01> 99.9% of rust problems can be solved without globals
/// * 01 has used them … once
/// <01> okay. I didn't write 1000 programs so far

// References 
// / Video Sources
// // Source https://youtu.be/U1EFgCNLDB8
// // Source https://www.youtube.com/watch?v=KLMtnA2mGKs
// / Linux Variables in Rust
// // https://doc.rust-lang.org/std/env/index.html

// Imports

use std::path::Path;
// / Check if path exists
// // https://stackoverflow.com/questions/32384594/how-to-check-whether-a-path-exists

use std::process::Command; 
// / To invoke commands
// // https://doc.rust-lang.org/std/process/struct.Command.html

use std::env;
// / To greb environment variables
// // https://doc.rust-lang.org/std/env/index.html

// Global Variables
static MSG: &'static str = "hello world"; // unsane, used for learning

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