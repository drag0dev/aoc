use std::fs::read_to_string;

fn part_two(numbers: Vec<u64>) {
    let len = numbers.len();
    let mut dp = vec![0; len];
    dp[len-1] = 1u128;
    for i in (0..len-1).rev() {
        if i+1 < len && numbers[i+1]-numbers[i] <= 3 { dp[i] += dp[i+1] }
        if i+2 < len && numbers[i+2]-numbers[i] <= 3 { dp[i] += dp[i+2] }
        if i+3 < len && numbers[i+3]-numbers[i] <= 3 { dp[i] += dp[i+3] }
    }
    println!("Part two: {}", dp[0]);
}

fn part_one(numbers: Vec<u64>) {
    let mut one_diff = 0;
    let mut three_diff = 0;
    let len = numbers.len();
    for i in 0..len-1 {
        match numbers[i+1] - numbers[i] {
            3 => three_diff += 1,
            1 => one_diff += 1,
            _ => {}
        }
    }
    println!("Part one: {}", one_diff * three_diff);
}

fn main() {
    let input = read_to_string("input").expect("reading input");
    let input = input.trim_end();
    let mut numbers = vec![0];
    for num in input.split("\n") {
        let num = num.parse::<u64>().unwrap();
        numbers.push(num);
    }
    numbers.sort_unstable();
    numbers.push(numbers.last().unwrap() + 3);
    part_one(numbers.clone());
    part_two(numbers.clone());
}
