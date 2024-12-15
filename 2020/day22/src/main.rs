use std::{collections::{HashSet, VecDeque}, fs::read_to_string};
use std::hash::{Hash, Hasher};
use std::collections::hash_map::DefaultHasher;

fn part_one(mut player1: VecDeque<u64>, mut player2: VecDeque<u64>) {
    while player1.len() != 0 && player2.len() != 0 {
        let player1_top = player1.pop_front().unwrap();
        let player2_top = player2.pop_front().unwrap();
        if player1_top > player2_top {
            player1.push_back(player1_top);
            player1.push_back(player2_top);
        } else {
            player2.push_back(player2_top);
            player2.push_back(player1_top);
        }
    }

    let mut winning_player = if player1.len() != 0 {player1} else {player2};
    let mut res = 0;
    let mut index = 1;
    while let Some(num) = winning_player.pop_back() {
        res += num * index;
        index += 1;
    }

    println!("Part one: {res}");
}

fn get_hash<T: Hash>(t: &T) -> u64 {
    let mut hasher = DefaultHasher::new();
    t.hash(&mut hasher);
    hasher.finish()
}

fn play_with_recursive(mut player1: VecDeque<u64>, mut player2: VecDeque<u64>) -> (i32, VecDeque<u64>) {
    let mut card_configs = HashSet::new();
    while player1.len() != 0 && player2.len() != 0 {
        let hash_player1 = get_hash(&player1);
        let hash_player2 = get_hash(&player2);
        if card_configs.contains(&(hash_player1, hash_player2)) { return (1, player1); }

        card_configs.insert((hash_player1, hash_player2));
        let player1_top = player1.pop_front().unwrap();
        let player2_top = player2.pop_front().unwrap();

        // should a recursive game be ran
        if player1_top as usize <= player1.len() && player2_top as usize <= player2.len() {
            let player1_recurs_cards = player1.range(0..player1_top as usize).copied().collect::<VecDeque<_>>();
            let player2_recurs_cards = player2.range(0..player2_top as usize).copied().collect::<VecDeque<_>>();
            let (inner_winner, _ker) = play_with_recursive(player1_recurs_cards, player2_recurs_cards);
            if inner_winner == 1 {
                player1.push_back(player1_top);
                player1.push_back(player2_top);
            } else {
                player2.push_back(player2_top);
                player2.push_back(player1_top);
            }
        } else {
            if player1_top > player2_top {
                player1.push_back(player1_top);
                player1.push_back(player2_top);
            } else {
                player2.push_back(player2_top);
                player2.push_back(player1_top);
            }
        }

    }

    if player1.len() != 0 {
        (1, player1)
    } else {
        (2, player2)
    }
}

fn part_two(player1: VecDeque<u64>, player2: VecDeque<u64>) {
    let (_, mut numbers) = play_with_recursive(player1.clone(), player2.clone());
    let mut res = 0;
    let mut index = 1;
    while let Some(num) = numbers.pop_back() {
        res += num * index;
        index += 1;
    }
    println!("Part two: {res}");
}

fn main() {
    let input = read_to_string("input").expect("reading input");
    let input = input.trim_end();
    let mut player1 = VecDeque::new();
    let mut player2 = VecDeque::new();
    let mut input_parts = input.split("\n\n");
    let player1_cards = input_parts.next().unwrap();
    let player2_cards = input_parts.next().unwrap();

    for player_card in player1_cards.split("\n").skip(1) {
        let player_card = player_card.parse::<u64>().unwrap();
        player1.push_back(player_card);
    }

    for player_card in player2_cards.split("\n").skip(1) {
        let player_card = player_card.parse::<u64>().unwrap();
        player2.push_back(player_card);
    }

    part_one(player1.clone(), player2.clone());
    part_two(player1.clone(), player2.clone());
}
