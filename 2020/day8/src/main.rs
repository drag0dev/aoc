use std::collections::HashSet;

#[derive(Debug, PartialEq, Clone)]
enum Instruction{
    NOP(i32),
    ACC(i32),
    JMP(i32),
}

fn main() {
    let cont = std::fs::read_to_string("input").expect("cant read input");
    let cont_trimmed = cont.trim();
    let mut instructions: Vec<Instruction> = Vec::with_capacity(cont.matches("\n").count()+1);

    // parse instructions
    let mut character;
    let mut num: i32;
    for line in cont_trimmed.split("\n"){
        character = line.chars().nth(0).unwrap();
        num = line[4..].parse::<i32>().unwrap();
        match character {
            'n' => {
                instructions.push(Instruction::NOP(num));
            },
            'a' => {
                instructions.push(Instruction::ACC(num));
            },
            'j' => {
                instructions.push(Instruction::JMP(num));
            },
            _ => unreachable!()
        }
    }

    let mut visited_instructions: HashSet<i32> = HashSet::new();

    // part one
    let mut acc: i32 = 0;
    let mut current_instruction: i32 = 0;
    loop {
        if !visited_instructions.insert(current_instruction) {break}
        match instructions.get(current_instruction as usize).unwrap() { // assume it never goes oob
            Instruction::NOP(_) => current_instruction += 1,
            Instruction::ACC(n) => {
                acc += n;
                current_instruction += 1;
            },
            Instruction::JMP(n) => current_instruction += *n,
        }

    }
    println!("Part one: {}", acc);

    // part two
    let mut temp_instruction: Instruction;
    for i in 0..instructions.len(){
        temp_instruction = instructions.get(i).unwrap().clone();
        match temp_instruction {
            Instruction::ACC(_) => continue,
            Instruction::NOP(n) => instructions[i] = Instruction::JMP(n),
            Instruction::JMP(n) => instructions[i] = Instruction::NOP(n),
        }

        let mut res = true;
        acc = 0;
        visited_instructions.clear();
        current_instruction = 0;

        while (current_instruction as usize) < instructions.len() {
            if !visited_instructions.insert(current_instruction) {
                res = false;
                break;
            }
            match instructions.get(current_instruction as usize).unwrap() { // assume it never goes oob
                Instruction::NOP(_) => current_instruction += 1,
                Instruction::ACC(n) => {
                    acc += n;
                    current_instruction += 1;
                },
                Instruction::JMP(n) => current_instruction += *n,
            }

        }
        if res {break}
        instructions[i] = temp_instruction;
    }
    println!("Part two: {}", acc);
}
