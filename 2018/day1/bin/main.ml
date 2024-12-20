let read_lines filename =
    let channel = open_in filename in

    let try_read () =
        try Some (input_line channel)
        with End_of_file -> None in

    let rec loop acc = match try_read () with
    | Some line -> loop (line :: acc)
    | None ->
            close_in channel;
            acc in
    loop [];;

let rec map_lines_to_number lines acc =
    match lines with
    | [] -> acc
    | h :: t ->
            let num = int_of_string h in
            let acc = num :: acc in
            map_lines_to_number t acc;;

module NumSet = Set.Make(Int);;
let rec find_duplicate_num current_cycle numbers seen acc =
    match NumSet.find_opt acc seen with
    | Some acc -> acc
    | None ->
            let seen = NumSet.add acc seen in
            let current_cycle = match List.length current_cycle with
            | 0 -> numbers
            | _ -> current_cycle in

            match current_cycle with
            | [] -> assert false
            | h :: t ->
                    let acc = acc + h in
                    find_duplicate_num t numbers seen acc;;

let part_one nums =
    let res = List.fold_left ( fun acc nums -> acc + nums ) 0 nums in
    Printf.printf "Part one: %d\n" res;;

let part_two nums =
    let res = find_duplicate_num nums nums NumSet.empty 0 in
    Printf.printf "Part two: %d\n" res;;


let lines = read_lines "input";;
let nums = map_lines_to_number lines [];;
part_one nums;;
part_two nums;;
