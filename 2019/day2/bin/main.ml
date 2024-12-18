let read_line filename =
    let channel = open_in filename in

    let try_read () =
        try Some (input_line channel)
        with End_of_file -> None in

    let read = match try_read () with
    | Some line -> line
    | None ->
            close_in channel;
            "" in
    read;;

let parse_line_to_list line =
    let nums_str = String.split_on_char ',' line in
    List.map int_of_string nums_str;;

let rec execute program opcode_index =
    let opcode = List.nth program opcode_index in
    match opcode with
    | 99 -> program
    | _ ->
            let left = List.nth program (opcode_index + 1) in
            let left = List.nth program left in

            let right = List.nth program (opcode_index + 2) in
            let right = List.nth program right in

            let target = List.nth program (opcode_index + 3) in

            let res = match opcode with
            | 1 -> left + right
            | 2 -> left * right
            | _ -> assert false in

            let updated_program = List.mapi (fun i x -> if i = target then res else x) program in

            execute updated_program (opcode_index + 4);;

let part_one program =
    let program = List.mapi (fun i x -> if i = 1 then 12 else if i = 2 then 2 else x) program in
    let program = execute program 0 in
    let first = List.nth program 0 in
    Printf.printf "Part one: %d\n" first;;

let find_noun_and_verb program =
    let try_combination noun_and_verb =
        let (noun, verb) = noun_and_verb in
        let program = List.mapi (fun i x -> if i = 1 then noun else if i = 2 then verb else x ) program in
        let updated_program = execute program 0 in
        let first = List.nth updated_program 0 in
        (first, noun, verb) in

    let combinations = List.init 100 (fun i -> List.init 100 (fun j -> (i, j))) in
    let combinations = List.flatten combinations in
    let combinations = List.map try_combination combinations in

    let (_, noun, verb) = List.find (fun res ->
        let (res, _, _) = res in
        match res with
        | 19690720 -> true
        | _ -> false
    ) combinations in
    (noun, verb);;

let part_two program =
    let (noun, verb) = find_noun_and_verb program in
    let res = 100 * noun + verb in
    Printf.printf "Part two: %d\n" res;;

let line = read_line "input";;
let nums = parse_line_to_list line;;
part_one nums;;
part_two nums;;
