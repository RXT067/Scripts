pub fn run() {
    use nix::unistd::getuid;
    let uid = getuid();

    println!("UID: {}", uid);
}
