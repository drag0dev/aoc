use std::fs;

fn main() {
    let contents = fs::read_to_string("input.txt").expect("There is a problem with a file!");
    // index 0 is start
    // index 1 is end
    let mut row: [i32; 2] = [0; 2];
    let mut column: [i32; 2] = [0; 2];
    let mut new_id: i32;
    let mut found_ids: Vec<i32> = Vec::new();

    let mut max: i32 = 0;
    for line in contents.split("\n"){
        row[0] = 0;
        row[1] = 127;
        column[0] = 0;
        column[1] = 7;

        for c in line.chars(){
            // F - lower half
            // B - upper half
            // L - left (lower) half
            // R - right (upper) half
            match c {
                'F' => {
                    row[1] = row[0] + (row[1] - row[0])/2;
                },
                'B' => {
                    row[0] = row[0] + (row[1] - row[0])/2 + 1;
                },
                'L' => {
                    column[1] = column[0] + (column[1] - column[0])/2;
                },
                'R' => {
                    column[0] = column[0] + (column[1] - column[0])/2 + 1;
                },
                _ => unreachable!(),
            }
            new_id = row[0]*8 + column[0];
            found_ids.push(new_id);
            if new_id > max{
                max = new_id;
            }
        }
    }
    // part one
    //println!("Max: {}", max);

    // part two
    found_ids.sort();
    for (i, _) in found_ids.iter().enumerate().skip(1){
        if found_ids.get(i).unwrap() - found_ids.get(i-1).unwrap() > 1 {
            println!("{} {}", found_ids.get(i).unwrap(), found_ids.get(i-1).unwrap());
        }
    }
    // output from ^
    // 4 0
    // 6 4
    // 620 618
}
