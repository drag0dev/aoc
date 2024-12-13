use std::fs::read_to_string;
use std::collections::HashMap;

fn apply_mask(mask: &String, mut number: u64) -> u64 {
    let mut temp_mask: u64;
    for (i, c) in mask.chars().rev().enumerate() {
        match c {
            '1' => {
                temp_mask = 1;
                temp_mask = temp_mask << i;
                number = number | temp_mask;
            },
            '0' => {
                temp_mask = 1;
                temp_mask = temp_mask << i;
                temp_mask = !temp_mask;
                number = number & temp_mask;
            }
            _ => {}
        }
    }
    number
}

fn apply_mask_floating(mask: &str, mask_index: usize, mut address: u64, number: u64, memory: &mut HashMap<u64, u64>) {
    let mut temp_mask: u64;
    if mask_index == mask.len() { memory.insert(address, number); }
    else {
        match mask.chars().rev().nth(mask_index as usize).unwrap() {
            '1' => {
                temp_mask = 1;
                temp_mask = temp_mask << mask_index;
                address = address | temp_mask;
                apply_mask_floating(mask, mask_index+1, address, number, memory);
            },
            '0' => apply_mask_floating(mask, mask_index+1, address, number, memory),
            'X' => {
                temp_mask = 1;
                temp_mask = temp_mask << mask_index;
                let address_inner = address | temp_mask;
                apply_mask_floating(mask, mask_index+1, address_inner, number, memory);

                temp_mask = 1;
                temp_mask = temp_mask << mask_index;
                temp_mask = !temp_mask;
                let address_inner = address & temp_mask;
                apply_mask_floating(mask, mask_index+1, address_inner, number, memory);

            }
            _ => {}
        }
    }
}

fn part_one(input: String) {
    let mut memory = HashMap::new();
    let mut mask = "".to_owned();
    for line in input.split("\n") {
        if line.starts_with("mask") { mask = line[7..].to_owned(); }
        else {
            let line = line.replace("mem[", "");
            let nums = line.split("] = ").collect::<Vec<&str>>();
            let address = nums[0].parse::<u64>().unwrap();
            let num = nums[1].parse::<u64>().unwrap();
            let num = apply_mask(&mask, num);
            memory.insert(address, num);
        }
    }
    let sum = memory.values()
        .fold(0, |acc, num| acc + num);
    println!("Part one: {sum}");
}


fn part_two(input: String) {
    let mut memory = HashMap::new();
    let mut mask = "".to_owned();
    for line in input.split("\n") {
        if line.starts_with("mask") { mask = line[7..].to_owned(); }
        else {
            let line = line.replace("mem[", "");
            let nums = line.split("] = ").collect::<Vec<&str>>();
            let address = nums[0].parse::<u64>().unwrap();
            let num = nums[1].parse::<u64>().unwrap();
            apply_mask_floating(&mask, 0, address, num, &mut memory);
        }
    }
    let sum = memory.values()
        .fold(0, |acc, num| acc + num);
    println!("Part two: {sum}");
}

fn main() {
    let input = read_to_string("input").expect("reading input");
    let input = input.trim_end();
    part_one(input.to_owned());
    part_two(input.to_owned());
}
