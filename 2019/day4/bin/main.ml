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

let parse_input line =
    let parts = String.split_on_char '-' line in
    let (start, eend) = match parts with
        | start :: eend :: _ -> (start, eend)
        | _ -> assert false in
    let start = int_of_string start in
    let eend = int_of_string eend in
    (start, eend);;


let rec does_password_contain_double password =
    match password with
    | [] -> false
    | [_] -> false
    | first :: second :: t ->
            match second == first with
            | true -> true
            | false -> does_password_contain_double (second :: t);;

module FreqMap = Map.Make(struct
  type t = char
  let compare = compare
end)

let does_password_contain_double_exclusive password =
    let freq = List.fold_left (fun acc digit ->
        match FreqMap.find_opt digit acc with
        | Some count -> FreqMap.add digit (count+1) acc
        | None -> FreqMap.add digit 1 acc
        ) FreqMap.empty password in

    let freq = FreqMap.to_list freq in
    List.fold_left ( fun acc (_, count) -> acc || ( count == 2)) false freq;;


let is_password_valid password double_fn =
    let rec is_password_increasing password =
        match password with
        | [] -> true
        | [_] -> true
        | first :: second :: t ->
                match second >= first with
                | false -> false
                | true -> is_password_increasing (second :: t) in

    let password = string_of_int password in
    let digits = String.to_seq password in
    let digits = List.of_seq digits in

    let is_increasing = is_password_increasing digits in
    let has_double = double_fn digits in
    is_increasing && has_double;;

let rec check_possible_paswords start eend count double_fn =
    match start == eend with
    | true -> count
    | false ->
            match is_password_valid start double_fn with
            | true -> check_possible_paswords (start+1) eend (count+1) double_fn
            | false -> check_possible_paswords (start+1) eend count double_fn;;


let part_one start eend =
    let valid_passwords = check_possible_paswords start eend 0 does_password_contain_double in
    Printf.printf "Part one: %d\n" valid_passwords;;

let part_two start eend =
    let valid_passwords = check_possible_paswords start eend 0 does_password_contain_double_exclusive in
    Printf.printf "Part two: %d\n" valid_passwords;;

let input_line = match read_lines "input" with
    | h :: _ -> h
    | _ -> assert false;;
let (start, eend) = parse_input input_line;;
part_one start eend;
part_two start eend;
