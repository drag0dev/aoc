use std::fs;
use std::collections::HashMap;

fn main() {
    let contents = fs::read_to_string("input.txt").expect("There is  a problem with the file!");
    let contents = contents.strip_suffix("\n").unwrap();
    let mut sum = 0;
    let mut number_of_lines;
    for group in contents.split("\n\n"){
        number_of_lines = group.split("\n").collect::<Vec<&str>>().len();
        let mut map: HashMap<char, usize> = HashMap::new();
        for line in group.split("\n"){
            for c in line.chars(){
                if map.contains_key(&c){
                    map.insert(c, map.get(&c).unwrap()+1);
                }else{
                    map.insert(c, 1);
                }
            }
        }

        for key in map.keys(){
            if map.get(&key).unwrap() == &number_of_lines{
                sum +=1;
            }
        }
    }

    println!("{}", sum);
}
