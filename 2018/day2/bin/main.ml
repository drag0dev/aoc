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

module Freq = Map.Make(Char);;

let rec map_id_to_counts s acc =
    match s with
    | [] -> acc
    | h :: t ->
            let acc =match Freq.find_opt h acc with
            | None -> Freq.add h 1 acc
            | Some count -> Freq.add h ( count + 1 ) acc in
            map_id_to_counts t acc;;

let rec does_id_have_n_repeating freq target =
    match freq with
    | [] -> false
    | (_, count) :: t ->
            match count = target with
            | false -> does_id_have_n_repeating t target
            | true -> true;;

let rec diff_between_two_strings s1 s2 total_diff =
    match (s1, s2) with
    | ([], []) -> total_diff == 1
    | ([], _::_) -> assert false
    | (_::_, []) -> assert false
    | (h1 :: t1, h2 :: t2) ->
            match h1 = h2 with
            | true -> diff_between_two_strings t1 t2 total_diff
            | false -> diff_between_two_strings t1 t2 ( total_diff + 1 )

let rec find_correct_pair left ids =
    match left with
    | [] -> assert false
    | h :: t ->
            let diffs = List.mapi ( fun i right -> (diff_between_two_strings right h 0, i) ) ids in
            let potential_match = List.find_opt (fun (is_match, _) -> is_match ) diffs in
            match potential_match with
            | None -> find_correct_pair t ids
            | Some (_, idx) ->
                    let right = List.nth ids idx in
                    (h, right);;

let rec print_correct_id s1 s2 =
    match (s1, s2) with
    | ([], []) -> ()
    | ([], _::_) -> ()
    | (_::_, []) -> ()
    | (h1 :: t1, h2 :: t2) ->
            match h1 = h2 with
            | true ->
                    Printf.printf "%c" h1;
                    print_correct_id t1 t2
            | false -> print_correct_id t1 t2;;


let part_one ids =
    let ids = List.map (fun id ->
        let id = String.to_seq id |> List.of_seq in
        map_id_to_counts id Freq.empty
    ) ids in
    let freqs = List.map (fun freq -> Freq.to_list freq ) ids in
    let freqs = List.map (fun freq ->
        let double = does_id_have_n_repeating freq 2 in
        let double = match double with false -> 0 | true -> 1 in

        let triple = does_id_have_n_repeating freq 3 in
        let triple = match triple with false -> 0 | true -> 1 in

        (double, triple)
    ) freqs in
    let (double, triple) = List.fold_left (fun (acc_double, acc_triple) (double, triple) -> (acc_double+double, acc_triple+triple) ) (0, 0) freqs in
    let res = double * triple in
    Printf.printf "Part one: %d\n" res;;

let part_two ids =
    let ids = List.map ( fun id -> String.to_seq id |> List.of_seq ) ids in
    let (left, right) = find_correct_pair ids ids in
    Printf.printf "Part two: ";
    print_correct_id left right;
    Printf.printf "\n";;

let lines = read_lines "input";;
part_one lines;;
part_two lines;;
