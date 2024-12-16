use std::{collections::HashMap, fs::read_to_string, mem::swap};

fn part_one(mut input: Vec<u32>) {
    let len = input.len();
    let mut current = 0;
    let min = *input.iter().min().unwrap();
    let max = *input.iter().max().unwrap();
    let mut helper = vec![0u32; len];

    for _ in 0..100 {
        let mut destination = input[current]-1;
        let mut first =  (current+1) % (len);
        let mut second = (current+2) % (len);
        let mut third =  (current+3) % (len);
        while input[first] == destination || input[second] == destination || input[third] == destination || destination < min {
            first =  (current+1) % (len);
            second = (current+2) % (len);
            third =  (current+3) % (len);
            if input[first] == destination || input[second] == destination || input[third] == destination { destination -= 1; }
            if destination < min { destination = max }
        }

        helper[0] = destination;
        helper[1] = input[first];
        helper[2] = input[second];
        helper[3] = input[third];

        let mut input_index = 0;
        let mut helper_index = 4;
        for (idx, num) in input.iter().enumerate() {
            if *num == destination {
                input_index = idx+1;
                break
            }
        }

        while helper_index < len {
            if input[input_index % (len)] != destination &&
            (input_index % (len)) != first &&
            (input_index % (len)) != third &&
            (input_index % (len)) != second {
                helper[helper_index] = input[input_index % (len)];
                helper_index += 1;
            }
            input_index += 1;
        }

        for (idx, num) in helper.iter().enumerate() { if *num == input[current] { current = idx+1; break; } }
        current = current % len;

        swap(&mut input, &mut helper);
    }

    let mut res = String::new();
    let mut index_of_1 = 0;
    for (idx, num) in input.iter().enumerate() { if *num == 1 { index_of_1 = idx; break; } }

    // right of '1'
    let mut index = index_of_1 + 1;
    while index < len {
        let c = char::from_digit(input[index], 10).unwrap();
        res.push(c);
        index += 1;
    }

    // left of '1'
    index = 0;
    while index < index_of_1 {
        let c = char::from_digit(input[index], 10).unwrap();
        res.push(c);
        index += 1;
    }

    println!("Part one: {res}");
}

fn part_two(input: Vec<u32>) {
    let mut ll = vec![(0u32, 0usize); 1_000_000];
    let mut index = 0;
    let mut max = *input.iter().max().unwrap();
    max += 1;
    let mut lookup = HashMap::new();

    for num in input.iter() {
        ll[index] = (*num, index+1);
        lookup.insert(*num, index);
        index += 1;
    }

    for _ in 0..(1_000_000 - input.len()) {
        ll[index] = (max, index+1);
        max += 1;
        index += 1;
    }
    ll[999999] = (ll[999999].0, 0);

    let mut current = 0;
    for _ in 0..(10_000_000-1){
        let mut destination_label = ll[current].0 - 1;

        let first = ll[ll[current].1];
        let second = ll[first.1];
        let third = ll[second.1];

        while first.0 == destination_label || second.0 == destination_label || third.0 == destination_label || destination_label < 1 {
            if first.0 == destination_label || second.0 == destination_label || third.0 == destination_label { destination_label -= 1; }
            if destination_label < 1 { destination_label = 1_000_000; }
        }
        let destination_index = if destination_label < 10 {
            *lookup.get(&destination_label).unwrap()
        } else {
            (destination_label - 1) as usize
        };

        let first_of_three_index = ll[current].1;
        let last_of_three_index = second.1;

        ll[current].1 = third.1;
        ll[last_of_three_index].1 = ll[destination_index].1;
        ll[destination_index].1 = first_of_three_index;
        current = ll[current].1;
    }

    let index_1 = *lookup.get(&1).unwrap();
    let res = ll[ll[index_1].1].0 as u128 * ll[ll[ll[index_1].1].1].0 as u128;
    println!("Part two: {res}");
}

fn main() {
    let input = read_to_string("input").expect("reading input");
    let input = input.trim_end();
    let input = input.chars()
        .map(|c| c.to_digit(10).unwrap())
        .collect::<Vec<u32>>();

    part_one(input.clone());
    part_two(input.clone());
}
