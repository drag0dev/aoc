use std::{collections::HashMap, fs::read_to_string};

fn traverse(key: &String, bags: &HashMap<String, Vec<(String, usize)>>, dp: &mut HashMap<String, bool>) -> bool {
    match dp.get(key) {
        Some(does_contain) => *does_contain,
        None => {
            // println!("{key} - missed cache");
            let does_contain = bags.get(key)
                .unwrap()
                .iter()
                .map(|(inner_key, _times)| {
                    if inner_key.starts_with("shiny gold") { true }
                    else {
                        match dp.get(inner_key) {
                            Some(does_contain) => *does_contain,
                            None => traverse(inner_key, bags, dp)
                        }
                    }
                })
                .fold(false, |acc, can_contain| { acc || can_contain });
            dp.insert(key.clone(), does_contain);
            does_contain
        }
    }
}

fn part_one(bags: HashMap<String, Vec<(String, usize)>>) {
    let mut dp: HashMap<String, bool> = HashMap::new();
    let mut count = 0;
    for key in bags.keys() {
        if traverse(key, &bags, &mut dp) { count += 1}
    }
    println!("Part one: {count}");
}

fn count(key: &String, bags: &HashMap<String, Vec<(String, usize)>>, dp: &mut HashMap<String, usize>) -> usize {
    match dp.get(key) {
        Some(count) => *count,
        None => {
            let count = bags.get(key)
                .unwrap()
                .iter()
                .map(|(inner_key, times)| {
                    match dp.get(inner_key) {
                        Some(count) => (*count) * times + times,
                        None => count(inner_key, bags, dp) * times + times
                    }
                })
                .fold(0, |acc, count| { acc + count });
            dp.insert(key.clone(), count);
            count
        }
    }
}

fn part_two(bags: HashMap<String, Vec<(String, usize)>>) {
    let mut dp: HashMap<String, usize> = HashMap::new();
    let count = count(&"shiny gold bags".to_string(), &bags, &mut dp);
    println!("Part two: {count}");
}

fn main() {
    let input = read_to_string("input").expect("reading input");
    let input = input.trim_end();
    let input = input.replace(".", "");
    let mut bags = HashMap::new();
    for line in input.split("\n") {
        let line: Vec<&str> = line.split(" contain ").collect();
        let key = line[0].to_string();
        bags.insert(key.clone(), vec![]);
        if line[1] != "no other bags" {
            for contained in line[1].split(", ") {
                let times = (&contained[0..1]).parse::<usize>().expect("parsing number");
                let mut contained_key = (&contained[2..]).to_string();
                if times == 1 { contained_key += "s"; }
                bags.get_mut(&key).unwrap().push((contained_key, times));
            }
        }
    }

    part_one(bags.clone());
    part_two(bags.clone());
}
