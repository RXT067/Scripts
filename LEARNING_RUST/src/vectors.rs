// Vectors - Resizable arrays

use std::mem;
// No need to use std::mem -> mem is sufficient

pub fn run() {
    let mut numbers: Vec<i32> = vec![1,2,3,4,5];

    // Re-assign value
    numbers[2] = 20;

    // Add on to vector
    numbers.push(5);
    numbers.push(6);

    // Pop off (remove) last value
    numbers.pop();

    println!("{:?}", numbers);

    // Get vector lenght
    println!("Vector Lenght: {}", numbers.len());

    // Get single value
    println!("Single Value: {}", numbers[0]);

    // Vectors are stack allocated
    println!("Array occupies {} bytes", mem::size_of_val(&numbers));

    // Get Slice
    let slice: &[i32] = &numbers[1..3];
    println!("Slice: {:?}", slice);

    // Loop through vector values
    for x in numbers.iter() {
        println!("Number: {}", x);
    }

    // Loop & mutate values
    for x in numbers.iter_mut() {
        *x *= 2;
    }

    println!("Numbers Vec: {:?}", numbers);
}