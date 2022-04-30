use std::fs;

fn update_degrees(degrees: i32, move_by: i32) -> i32{
    let mut degrees = degrees + move_by;
    while degrees < 0{
        degrees += 360;
    }
    while degrees >= 360{
        degrees -= 360;
    }

    degrees
}

fn main() {
    let contents = fs::read_to_string("input.txt")
        .expect("There is a problem with the file!");
    let contents = contents.strip_suffix("\n")
        .unwrap();
    let mut north = 0;
    let mut east = 0;
    let mut turn_degress = 0;
    // start facing east
    // 0 - east
    // 90 - north
    // 180 - west
    // 270 - south

    // part one
    let mut num: i32;
    for line in contents.split("\n"){
        num = line[1..].parse::<i32>().unwrap();
        if line.find("R").is_some(){
            turn_degress = update_degrees(turn_degress, (-1) * num);
        }else if line.find("L").is_some(){
            turn_degress = update_degrees(turn_degress, num);
        }else if line.find("N").is_some(){
            north += num;
        }else if line.find("S").is_some(){
            north -= num;
        }else if line.find("E").is_some(){
            east += num;
        }else if line.find("W").is_some(){
            east -= num;
        }else {
            match turn_degress {
                0 => east += num,
                90 => north += num,
                180 => east -= num,
                270 => north -= num,
                _ => unreachable!(),
            }
        }
    }

    println!("Part one: {}", north.abs() + east.abs());

    // part two
    north = 0;
    east = 0;
    let mut waypoint_north: i32 = 1;
    let mut waypoint_east: i32 = 10;
    let mut temp: i32;
    for line in contents.split("\n"){
        num = line[1..].parse::<i32>().unwrap();
        if line.find("R").is_some(){
            match num {
                90 => {
                    temp = waypoint_east;
                    waypoint_east = waypoint_north;
                    waypoint_north = -temp;
                },
                180 => {
                    waypoint_north = -waypoint_north;
                    waypoint_east = -waypoint_east;
                },
                270 => {
                    temp = waypoint_east;
                    waypoint_east = -waypoint_north;
                    waypoint_north = temp;
                },
                _ => unreachable!(),
            }
        }else if line.find("L").is_some(){
            match num {
                90 => {
                    temp = waypoint_east;
                    waypoint_east = -waypoint_north;
                    waypoint_north = temp;
                },
                180 => {
                    waypoint_north = -waypoint_north;
                    waypoint_east = -waypoint_east;
                },
                270 => {
                    temp = waypoint_east;
                    waypoint_east = waypoint_north;
                    waypoint_north = -temp;
                },
                _ => unreachable!(),
            }
        }else if line.find("N").is_some(){
            waypoint_north += num;
        }else if line.find("S").is_some(){
            waypoint_north -= num;
        }else if line.find("E").is_some(){
            waypoint_east += num;
        }else if line.find("W").is_some(){
            waypoint_east -= num;
        }else {
            north += num * waypoint_north;
            east += num * waypoint_east;
        }
        println!("Ship: N{} E{}", north, east);
        println!("waypoint: N{} E{}\n", waypoint_north, waypoint_east);
    }
    println!("Part two: {}", north.abs() + east.abs());
}
