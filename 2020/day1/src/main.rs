use std::fs;

fn main() {
    let contents = fs::read_to_string("input.txt").expect("Something is wrong with the file!");
    let mut nums: Vec<i32> = Vec::new();
    for line in contents.split("\n"){
        if line.len() == 0 {
            break;
        }
        nums.push(line.parse::<i32>().unwrap());
    }

    // part one
    'one: for a in nums.iter(){
        for b in nums.iter(){
            if a + b == 2020{
                println!("{}", a*b);
                break 'one;
            }
        }
    }

    // part two
    'two: for a in nums.iter(){
        for b in nums.iter(){
            for c in nums.iter(){
                if a + b + c == 2020{
                    println!("{}", a*b*c);
                    break 'two;
                }
            }
        }
    }
}
