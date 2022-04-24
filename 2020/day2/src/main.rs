use std::fs;

fn main() {
    let contents = fs::read_to_string("input.txt").expect("Something is wrong with the file!");
    let mut valid_pw_one: i32 = 0;
    let mut valid_pw_two: i32 = 0;
    for line in contents.split("\n"){
        if line.len() == 0 {
            break;
        }
        let mut line_split = line.split(":");
        let rule = line_split.nth(0).unwrap();
        let pw = line_split.nth(0).unwrap().strip_prefix(" ").unwrap();
        let letter = rule.split(" ").nth(1).unwrap();
        let min = rule.split(" ").nth(0).unwrap().split("-").nth(0).unwrap().parse::<i32>().unwrap();
        let max = rule.split(" ").nth(0).unwrap().split("-").nth(1).unwrap().parse::<i32>().unwrap();

        let mut count = 0;
        let letter = letter.as_bytes()[0] as char;

        // part one
        for c in pw.to_string().chars() {
            if c == letter{
                count += 1;
            }
        }
        if count >= min && count <= max{
            valid_pw_one += 1;
        }

        // part two
        let first_pos = pw.chars().nth((min-1) as usize).unwrap() == letter;
        let second_pos = pw.chars().nth((max-1) as usize).unwrap() == letter;
        if first_pos != second_pos {
            valid_pw_two +=1;
        }

    }
    println!("Part one: {}", valid_pw_one);
    println!("Part two: {}", valid_pw_two);
}
