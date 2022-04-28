use std::fs;

fn main() {
    let contents = fs::read_to_string("input.txt").expect("There is a problem with the file!");
    let contents = contents.strip_suffix("\n").unwrap();
    let contents = contents.replace("\n", " ");
    let mut numbers: Vec<i64> = Vec::new();
    for num in contents.split(" "){
        numbers.push(num.parse::<i64>().unwrap());
    }

    let mut j;
    let mut found: bool;
    for (i, num) in numbers.iter().enumerate().skip(25){
        j = i - 25;
        found = false;
        'outer: for (k, number_one) in numbers[j..i].iter().enumerate(){
            for (l, number_two) in numbers[j..i].iter().enumerate(){
                if l == k{
                    continue;
                }
                if &(number_one + number_two) == num{
                    found = true;
                    break 'outer;
                }
            }
        }
        if !found{
            println!("Part one: {}", num);
            let mut i = 0;
            let mut min: i64;
            let mut max: i64;
            let mut sum: i64;
            loop {
                sum = 0;
                min = numbers.iter().skip(i).nth(0).unwrap().clone();
                max = numbers.iter().skip(i).nth(0).unwrap().clone();
                for temp in numbers.iter().skip(i){
                    sum += temp;
                    if temp < &min{
                        min = *temp;
                    }
                    if temp > &max {
                        max = *temp;
                    }
                    if &sum > num{
                        break;
                    }else if &sum == num{
                        break;
                    }
                }
                if sum == *num{
                    println!("Part two: {}", min + max);
                    break;
                }
                i +=1;
            }
            break;
        }
    }
}
