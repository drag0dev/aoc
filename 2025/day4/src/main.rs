use std::fs::read_to_string;

const DIRECTIONS: [(i64, i64); 8] = [(-1, -1), (0, -1), (1, -1), (-1, 0), (1, 0), (-1, 1), (0, 1), (1, 1)];

fn process_input(input: &str) -> (i64, i64, Vec<Vec<i64>>) {
    let mut res = Vec::new();

    let char_grid = input.lines().map(|line| line.chars().collect::<Vec<char>>()).collect::<Vec<_>>();
    let height = char_grid.len() as i64;
    let width = char_grid[0].len() as i64;

    let mut x: i64 = 0;
    let mut y: i64 = 0;
    let mut row = Vec::new();
    loop {
        if x == width {
            x = 0;
            y += 1;
            res.push(row);
            row = Vec::new();
        }
        if y == height { break; }

        if char_grid[y as usize][x as usize] == '.' {
            row.push(-1)
        } else {
            let mut count = 0;
            for (x_diff, y_diff) in DIRECTIONS.iter() {
                let new_x = x+x_diff;
                let new_y = y+y_diff;
                if new_x >= 0 && new_y >= 0 && new_x < width && new_y < height && char_grid[new_y as usize][new_x as usize] == '@' {
                    count += 1;
                }
            }
            row.push(count);
        }
        x += 1;
    }
    (height, width, res)
}

fn step_remove(grid: &Vec<Vec<i64>>, height: i64, width: i64) -> (u64, Vec<Vec<i64>>) {
    let mut new_grid = grid.clone();
    let mut x: i64 = 0;
    let mut y: i64 = 0;
    let mut rolls_removed = 0;
    loop {
        if x == width {
            x = 0;
            y += 1;
        }
        if y == height { break; }

        let curr_count = grid[y as usize][x as usize];
        if (0..4).contains(&curr_count) {
            rolls_removed += 1;

            new_grid[y as usize][x as usize] = -1;
            for (x_diff, y_diff) in DIRECTIONS.iter() {
                let new_x = x+x_diff;
                let new_y = y+y_diff;
                if new_x >= 0 && new_y >= 0 && new_x < width && new_y < height && grid[new_y as usize][new_x as usize] != 0{
                    new_grid[new_y as usize][new_x as usize] -= 1;
                }
            }
        }

        x += 1;
    }

    (rolls_removed, new_grid)
}

fn step_remove_in_place(grid: &mut Vec<Vec<i64>>, height: i64, width: i64) -> u64 {
    let mut x: i64 = 0;
    let mut y: i64 = 0;
    let mut rolls_removed = 0;
    loop {
        if x == width {
            x = 0;
            y += 1;
        }
        if y == height { break; }

        let curr_count = grid[y as usize][x as usize];
        if (0..4).contains(&curr_count) {
            rolls_removed += 1;

            grid[y as usize][x as usize] = -1;
            for (x_diff, y_diff) in DIRECTIONS.iter() {
                let new_x = x+x_diff;
                let new_y = y+y_diff;
                if new_x >= 0 && new_y >= 0 && new_x < width && new_y < height && grid[new_y as usize][new_x as usize] != 0{
                    grid[new_y as usize][new_x as usize] -= 1;
                }
            }
        }

        x += 1;
    }

    rolls_removed
}

fn main() {
    let input = read_to_string("./input").unwrap();
    let (height, width, mut grid) = process_input(&input);
    let (part_one, _) = step_remove(&grid, height, width);

    let mut part_two = 0;
    loop {
        let rolls_removed = step_remove_in_place(&mut grid, height, width);
        if rolls_removed == 0 { break; }
        part_two += rolls_removed;
    }
    println!("Part one: {part_one}");
    println!("Part one: {part_two}");
}
