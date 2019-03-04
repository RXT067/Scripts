// Arrays - Fixes list where elements are the same data types

use std::mem;
// No need to use std::mem -> mem is sufficient

pub fn run() {
    let mut numbers: [i32; 5] = [1,2,3,4,5];
    // Fails if 4 values are present and is set to 5
    // Fails if value is not i32 if set i32

    // Re-assign value
        // Grab second value (if set on second) and change it on 20
    numbers[2] = 20;

    println!("{:?}", numbers);

    // Get array lenght
    println!("Array Lenght: {}", numbers.len());

    // Get single value
    println!("Single Value: {}", numbers[0]);

    // Arrays are stack allocated
        // Outputs how much bytes array occupies
    println!("Array occupies {} bytes", mem::size_of_val(&numbers));

    // Get Slice
    let slice: &[i32] = &numbers[0..2]; // grabs 0 ~ 2 values from var
    println!("Slice: {:?}", slice);
}