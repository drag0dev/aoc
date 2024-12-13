use std::{collections::HashMap, fs::read_to_string};

fn part_one(numbers: Vec<u64>) {
    let mut rounds = HashMap::new();
    let mut last_spoken = *numbers.last().unwrap() as i64;
    let mut round: i64 = 1;
    for num in numbers {
        rounds.insert(num as i64, [-1, round]);
        round += 1;
    }

    while round < 2021 {
        let previous_rounds = rounds.get(&last_spoken).unwrap();
        if previous_rounds[0] == -1 { last_spoken = 0; }
        else { last_spoken = previous_rounds[1]-previous_rounds[0]; }

        match rounds.get_mut(&last_spoken) {
            Some(previous_rounds) => {
                previous_rounds[0] = previous_rounds[1];
                previous_rounds[1] = round;
            },
            None => { rounds.insert(last_spoken, [-1, round]); }
        }
        round += 1;
    }
    println!("Part one: {last_spoken}");
}

// same bruteforce just works, not too slow - ~30s on my machine
fn part_two(numbers: Vec<u64>) {
    let mut rounds = HashMap::new();
    let mut last_spoken = *numbers.last().unwrap() as i64;
    let mut round: i64 = 1;
    for num in numbers {
        rounds.insert(num as i64, [-1, round]);
        round += 1;
    }

    while round < 30000001 {
        let previous_rounds = rounds.get(&last_spoken).unwrap();
        if previous_rounds[0] == -1 { last_spoken = 0; }
        else { last_spoken = previous_rounds[1]-previous_rounds[0]; }

        match rounds.get_mut(&last_spoken) {
            Some(previous_rounds) => {
                previous_rounds[0] = previous_rounds[1];
                previous_rounds[1] = round;
            },
            None => { rounds.insert(last_spoken, [-1, round]); }
        }
        round += 1;
    }
    println!("Part two: {last_spoken}");
}

fn main() {
    let input = read_to_string("input").expect("reading input");
    let input = input.trim_end();
    let mut numbers = Vec::new();
    for num in input.split(",") {
        let num = num.parse::<u64>().unwrap();
        numbers.push(num);
    }
    part_one(numbers.clone());
    part_two(numbers.clone());
}
