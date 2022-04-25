use std::fs;

fn main() {
    let contents = fs::read_to_string("input.txt").expect("There is a problem with the file!");
    let mut valid = 0;

    'outer: for passport in contents.split("\n\n"){
        // if passport has required fields check for part two
        if passport.contains("byr") &&
            passport.contains("iyr") &&
            passport.contains("eyr") &&
            passport.contains("hgt") &&
            passport.contains("hcl") &&
            passport.contains("ecl") &&
            passport.contains("pid"){
            // part one
            // valid +=1;
            for field in passport.replace("\n", " ").split(" "){
                match field.split(":").nth(0).unwrap() {
                    "byr" => {
                        let num = field.split(":").nth(1).unwrap().parse::<i32>().unwrap();
                        if num < 1920 || num > 2002{
                            continue 'outer;
                        }
                    },
                    "iyr" => {
                        let num = field.split(":").nth(1).unwrap().parse::<i32>().unwrap();
                        if num < 2010 || num > 2020{
                            continue 'outer;
                        }
                    },
                    "eyr" => {
                        let num = field.split(":").nth(1).unwrap().parse::<i32>().unwrap();
                        if num < 2020 || num > 2030{
                            continue 'outer;
                        }
                    },
                    "hgt" => {
                        let field = field.split(":").nth(1).unwrap();
                        if field.contains("in"){
                            let num = field.replace("in", "").parse::<i32>().unwrap();
                            if num < 59 || num > 76{
                                continue 'outer;
                            }
                        }else if field.contains("cm"){
                            let num = field.replace("cm", "").parse::<i32>().unwrap();
                            if num < 150 || num > 193{
                                continue 'outer;
                            }
                        }else {
                            continue 'outer;
                        }
                    },
                    "hcl" => {
                        let value = field.split(":").nth(1).unwrap();
                        // # has to be first character
                        if value.chars().nth(0).unwrap() != '#'{
                            continue 'outer;
                        }else{
                            let mut no_chars = 0;
                            for c in value.chars().skip(1){
                                if !((c >= '0' && c<='9' ) || (c >= 'a' || c <= 'f')){
                                    continue 'outer;
                                }
                                no_chars +=1;
                            }

                            if no_chars != 6 {
                                continue 'outer;
                            }
                        }
                    },
                    "ecl" => {
                        let value = field.split(":").nth(1).unwrap();
                        if !(value.contains("amb") ||
                            value.contains("blu") ||
                            value.contains("brn") ||
                            value.contains("gry") ||
                            value.contains("grn") ||
                            value.contains("hzl") ||
                            value.contains("oth")){
                                continue 'outer;
                        }
                    },
                    "pid" => {
                        if field.split(":").nth(1).unwrap().len() != 9{
                            continue 'outer;
                        }
                        if !field.split(":").nth(1).unwrap().parse::<i128>().is_ok(){
                            continue 'outer;
                        }
                    },
                    _ => {},
                }
            }
            valid +=1;
        }
    }

    println!("Valid: {}", valid);
}
