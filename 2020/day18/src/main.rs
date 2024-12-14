use std::fs::read_to_string;

#[derive(Debug, PartialEq, Copy, Clone)]
enum Token {
    Number(u128),
    Operator(char)
}

fn tokenize(input: &str) -> Vec<Token> {
    let mut expression = Vec::new();
    let mut number_acc = 0;
    let mut is_number = false;
    for c in input.chars() {
        if c == ' ' {
            if is_number {
                expression.push(Token::Number(number_acc));
                is_number = false;
                number_acc = 0;
            }
        } else if c.is_numeric() {
            is_number = true;
            let c = c.to_digit(10).unwrap() as u128;
            number_acc *= 10;
            number_acc += c;
        } else {
            if is_number {
                expression.push(Token::Number(number_acc));
                is_number = false;
                number_acc = 0;
            }
            expression.push(Token::Operator(c));
        }
    }
    if is_number { expression.push(Token::Number(number_acc)); }
    expression
}

fn precedence(left: char, right: char) -> bool {
    let left_precedence = match left {
        '+' => 1,
        '*' => 1,
        '(' => 0,
        ')' => 0,
        _ => unreachable!(),
    };
    let right_precedence = match right {
        '+' => 1,
        '*' => 1,
        '(' => 0,
        ')' => 0,
        _ => unreachable!(),
    };

    left_precedence >= right_precedence
}

fn precedence_part_two(left: char, right: char) -> bool {
    let left_precedence = match left {
        '+' => 2,
        '*' => 1,
        '(' => 0,
        ')' => 0,
        _ => unreachable!(),
    };
    let right_precedence = match right {
        '+' => 2,
        '*' => 1,
        '(' => 0,
        ')' => 0,
        _ => unreachable!(),
    };

    left_precedence >= right_precedence
}

fn expression_to_pn(expression: Vec<Token>) -> Vec<Token> {
    let mut stack = Vec::new();
    let mut res = Vec::new();
    for token in expression {
        match token {
            Token::Number(_) => res.push(token),
            Token::Operator('(') => stack.push(token),
            Token::Operator(')') => {
                while let Some(Token::Operator(op)) = stack.last() {
                    if *op == '(' {
                        stack.pop();
                        break;
                    }
                    res.push(stack.pop().unwrap());
                }
            }
            Token::Operator(op) => {
                while let Some(Token::Operator(stack_op)) = stack.last() {
                    if *stack_op == '(' || !precedence(*stack_op, op) {
                        break;
                    }
                    res.push(stack.pop().unwrap());
                }
                stack.push(token);
            }
        }
    }
    while !stack.is_empty() { res.push(stack.pop().unwrap()); }
    res
}

fn expression_to_pn_part_two(expression: Vec<Token>) -> Vec<Token> {
    let mut stack = Vec::new();
    let mut res = Vec::new();
    for token in expression {
        match token {
            Token::Number(_) => res.push(token),
            Token::Operator('(') => stack.push(token),
            Token::Operator(')') => {
                while let Some(Token::Operator(op)) = stack.last() {
                    if *op == '(' {
                        stack.pop();
                        break;
                    }
                    res.push(stack.pop().unwrap());
                }
            }
            Token::Operator(op) => {
                while let Some(Token::Operator(stack_op)) = stack.last() {
                    if *stack_op == '(' || !precedence_part_two(*stack_op, op) {
                        break;
                    }
                    res.push(stack.pop().unwrap());
                }
                stack.push(token);
            }
        }
    }
    while !stack.is_empty() { res.push(stack.pop().unwrap()); }
    res
}

fn evalute_pn_expression(expression: &Vec<Token>) -> u128 {
    let mut stack = Vec::new();
    for token in expression {
        match token {
            Token::Number(num) => stack.push(*num),
            Token::Operator(op) => {
                let right = stack.pop().unwrap();
                let left = stack.pop().unwrap();
                let res = match op {
                    '+' => left + right,
                    '*' => left * right,
                    _ => unreachable!()
                };
                stack.push(res);
            }
        }
    }
    stack.pop().unwrap()
}

fn part_one(expressions: Vec<Vec<Token>>) {
    let expressions: Vec<Vec<Token>> = expressions.into_iter().map(|expression| expression_to_pn(expression)).collect::<_>();
    let res = expressions.iter()
        .map(|exp| evalute_pn_expression(&exp))
        .fold(0, |acc, exp| acc + exp);
    println!("Part one: {res}");
}

fn part_two(expressions: Vec<Vec<Token>>) {
    let expressions: Vec<Vec<Token>> = expressions.into_iter().map(|expression| expression_to_pn_part_two(expression)).collect::<_>();
    let res = expressions.iter()
        .map(|exp| evalute_pn_expression(&exp))
        .fold(0, |acc, exp| acc + exp);
    println!("Part two: {res}");
}

fn main() {
    let input = read_to_string("input").expect("reading input");
    let input = input.trim_end();
    let expressions = input.split("\n")
        .map(|expression| tokenize(expression))
        .collect::<Vec<Vec<Token>>>();

    part_one(expressions.clone());
    part_two(expressions);
}
