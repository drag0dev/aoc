use std::fs;

fn slope(right: i32, down: usize, contents: &String) -> i32{
    // 31 is the number of characters in a line
    // 323 lines in the input
    let hor_len: i32 = 31;
    let mut j: i32 = 0;
    let mut index: usize;
    let mut trees = 0;

    for i in (0..323).step_by(down){
        index = ((i * hor_len) + j) as usize;
        if contents.chars().nth(index).unwrap() == '#'{
            trees +=1;
        }

        j += right;
        if j >= hor_len{
            j = j - hor_len;
        }
    }

    trees
}

fn main() {
    let contents = fs::read_to_string("input.txt").expect("There is a problem with a file!");
    let contents = contents.replace("\n", "");

    let one_one = slope(1, 1, &contents);
    let three_one = slope(3, 1, &contents);
    let five_one = slope(5, 1, &contents);
    let seven_one = slope(7, 1, &contents);
    let one_two = slope(1, 2, &contents);
    let res: i128 = one_one as i128 * three_one as i128 * five_one as i128 * seven_one as i128 * one_two as i128;
    println!("{}", res);
}
