use std::fs;
use std::collections::HashMap;

fn apply_mask(mask: &str, number: &mut u64){
    let mut temp_mask: u64;
    for (i, c) in mask.chars().rev().enumerate(){
        if c == '1'{
            temp_mask = 1;
            temp_mask = temp_mask << i;
            *number = *number | temp_mask;
        }else if c == '0'{
            temp_mask = 1;
            temp_mask = temp_mask << i;
            temp_mask = !temp_mask;
            *number = *number & temp_mask;
        }
    }
}

fn main() {
    let contents = fs::read_to_string("input.txt")
        .unwrap();
    let contents = contents.strip_suffix("\n")
        .unwrap();

    let mut memory: HashMap<&str, u64> = HashMap::new();
    let mut sum: u64 = 0;
    let mut mask: &str = "";
    let mut key: &str;
    let mut num: u64;

    // part one
    for line in contents.split("\n"){
        if line.find("mask").is_some(){
            mask = &line[line.find("=").unwrap()+2..];
        }else {
            key = &line[line.find('[').unwrap()+1..line.find(']').unwrap()];
            num = line[line.find('=').unwrap()+2..].parse::<u64>().unwrap();

            // part one
            apply_mask(mask, &mut num);
            memory.insert(key, num);
        }
    }

    for value in memory.values(){
        sum += value;
    }
    println!("Part one: {}", sum);
}
