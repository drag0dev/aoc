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

let rec consume_string s stack =
    match s with
    | [] -> List.rev stack
    | current :: t ->
            let stack = match stack with
            | [] -> current :: stack
            | top :: t ->
                    match abs ( top - current ) = 32 with
                    | true -> t
                    | false -> current :: stack in

            consume_string t stack;;

module UnitSet = Set.Make(Int);;
let rec unique_units polymer unique =
    match polymer with
    | [] -> unique
    | h :: t ->
            let h = match h >= 97 with
            | false -> h
            | true -> h - 32 in
            let unique = UnitSet.add h unique in
            unique_units t unique;;

let part_one input =
    consume_string input []
    |> List.length
    |> Printf.printf "Part one: %d\n";;

let part_two polymer =
    unique_units polymer UnitSet.empty
    |> UnitSet.to_list
    |> List.map (fun u ->
            let polymer = List.filter (fun c -> not (c == u || c == (u + 32)) ) polymer in
            let res = consume_string polymer [] in
            List.length res
        )
    |> List.fold_left (fun acc len -> min acc len) 999999999999999
    |> Printf.printf "Part two: %d\n" ;;


let line = match read_lines "input" with
    | h :: [] -> h
    | _ -> assert false;;
let input = String.to_seq line |> List.of_seq;;
let input = List.map (fun c -> Char.code c) input;;
part_one input;;
part_two input;;
