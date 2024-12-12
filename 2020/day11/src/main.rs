use std::fs::read_to_string;

fn count_occupied(input: &Vec<Vec<char>>, height: usize, width: usize) -> usize {
    let mut count = 0;
    for i in 0..height {
        for j in 0..width {
            if input[i][j] == '#' {
                count += 1;
            }
        }
    }
    count
}

fn check_occupied_adjecant(input: &Vec<Vec<char>>, x: i32, y: i32, height: usize, width: usize) -> usize {
    let mut count = 0;
    let directions = [(-1, 0), (1, 0), (0, -1), (0, 1), (-1, -1), (-1, 1), (1, 1), (1, -1)];
    for direction in directions {
        let (x_diff, y_diff) = direction;
        if x+x_diff >= 0 && x+x_diff < height as i32 && y+y_diff >= 0 &&
            y+y_diff < width as i32 && input[(x+x_diff) as usize][(y+y_diff) as usize] == '#' { count += 1; }
    }
    count
}

fn step(input: &Vec<Vec<char>>) -> (Vec<Vec<char>>, bool) {
    let height = input.len();
    let width = input[0].len();
    let mut result = input.clone();
    let mut change = false;
    for i in 0..height {
        for j in 0..width {
            match input[i][j] {
                'L' => {
                    if check_occupied_adjecant(&input, i as i32, j as i32, height, width) == 0 {
                        result[i][j] = '#';
                        change = true;
                    }
                },
                '#' => {
                    if check_occupied_adjecant(&input, i as i32, j as i32, height, width) >= 4 {
                        result[i][j] = 'L';
                        change = true;
                    }
                },
                '.' => {},
                _ => unreachable!()
            }
        }
    }
    (result, change)
}

fn part_one(input: Vec<Vec<char>>) {
    let mut change;
    let mut input = input;
    let count = loop {
        (input, change) = step(&input);
        if !change {
            let count = count_occupied(&input, input.len(), input[0].len());
            break count;
        }
    };
    println!("Part one: {count}");
}

fn count_occupied_in_directions(input: &Vec<Vec<char>>, x: i32, y: i32, height: usize, width: usize) -> usize {
    let mut count = 0;
    let directions = [(-1, 0), (1, 0), (0, -1), (0, 1), (-1, -1), (-1, 1), (1, 1), (1, -1)];
    for direction in directions {
        let (x_diff, y_diff) = direction;
        let mut inner_x = x+x_diff;
        let mut inner_y = y+y_diff;
        while inner_x >= 0 && inner_x < height as i32 && inner_y >= 0 && inner_y < width as i32 {
            match input[inner_x as usize][inner_y as usize] {
                '.' => {
                    inner_x += x_diff;
                    inner_y += y_diff;
                }
                'L' => { break }
                '#' => {
                    count += 1;
                    break
                }
                _ => unreachable!()
            }
        }
    }
    count
}

fn step_part_two(input: &Vec<Vec<char>>) -> (Vec<Vec<char>>, bool) {
    let height = input.len();
    let width = input[0].len();
    let mut result = input.clone();
    let mut change = false;
    for i in 0..height {
        for j in 0..width {
            match input[i][j] {
                'L' => {
                    if count_occupied_in_directions(&input, i as i32, j as i32, height, width) == 0 {
                        result[i][j] = '#';
                        change = true;
                    }
                },
                '#' => {
                    if count_occupied_in_directions(&input, i as i32, j as i32, height, width) >= 5 {
                        result[i][j] = 'L';
                        change = true;
                    }
                },
                '.' => {},
                _ => unreachable!()
            }
        }
    }
    (result, change)
}

fn part_two(input: Vec<Vec<char>>) {
    let mut change;
    let mut input = input;
    let count = loop {
        (input, change) = step_part_two(&input);
        if !change {
            let count = count_occupied(&input, input.len(), input[0].len());
            break count;
        }
    };
    println!("Part two: {count}");
}

fn main() {
    let input = read_to_string("input").expect("reading input");
    let input = input.trim_end();
    let mut input_string = Vec::new();
    for line in input.split("\n") {
        let line = line.chars().collect::<Vec<char>>();
        input_string.push(line);
    }
    part_one(input_string.clone());
    part_two(input_string.clone());
}
