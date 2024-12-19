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

let rec take l n acc =
    match n with
    | 0 ->
            let acc = List.rev acc in
            (l, acc)
    | _ ->
        match l with
        | [] -> assert false
        | h :: t ->
                let acc = h :: acc in
                take t (n - 1) acc;;

let rec split_input_into_frames input frames =
    match input with
    | [] -> frames
    | _ ->
            let (input, frame) = take input ( 25 * 6 ) [] in
            let frames = frame :: frames in
            split_input_into_frames input frames;;

let map_frame_to_counts frame =
    let rec count_in_frame frame target count =
        match frame with
        | [] -> count
        | h :: t ->
                match h = target with
                | true -> count_in_frame t target ( count + 1)
                | false -> count_in_frame t target count in
    let zero_count = count_in_frame frame '0' 0 in
    let one_count = count_in_frame frame '1' 0 in
    let two_count = count_in_frame frame '2' 0 in
    (zero_count, one_count, two_count);;

let rec combine_pixels frames idx current_frame number_of_frames =
    match current_frame = number_of_frames with
    | true -> assert false
    | false ->
        let frame = List.nth frames current_frame in
        match List.nth frame idx with
        | '2' -> combine_pixels frames idx ( current_frame + 1 ) number_of_frames
        | color -> color;;

let rec combine_frames frames idx total_len number_of_frames res =
    match idx = total_len with
    | true -> List.rev res
    | false ->
            let pixel = combine_pixels frames idx 0 number_of_frames in
            let res = pixel :: res in
            combine_frames frames ( idx + 1 ) total_len number_of_frames res;;

let rec print_picture frame idx width total_len =
    match idx = total_len with
    | true ->
            ()
    | false ->
        let pixel = List.nth frame idx in
        let pixel = match pixel with
        | '0' -> ' '
        | '1' -> '#'
        | _ -> assert false in

        match (( idx + 1 ) mod width ) = 0 && idx != 0 with
            | true ->
                    Printf.printf "%c\n" pixel;
                    print_picture frame ( idx + 1) width total_len
            | false ->
                    Printf.printf "%c" pixel;
                    print_picture frame ( idx + 1) width total_len;;

let part_one frames =
    let frames = List.map (fun frame -> map_frame_to_counts frame) frames in
    let frames = List.sort (fun left right ->
        let (zeroes_left, _, _) = left in
        let (zeroes_right, _, _) = right in
        compare zeroes_left zeroes_right
    ) frames in

    let (_, ones, twos) = List.nth frames 0 in
    let res = ones * twos in
    Printf.printf "Part one: %d\n" res;;

let part_two frames =
    Printf.printf "Part two:\n";
    let number_of_frames = List.length frames in
    let total_len = 25 * 6 in
    let res_image = combine_frames frames 0 total_len number_of_frames [] in
    print_picture res_image 0 25 ( 25 * 6 );;


let line = match read_lines "input" with
    | line :: _ -> line
    | _ -> assert false;;
let line = String.to_seq line |> List.of_seq;;
let frames = split_input_into_frames line [];;
let frames = List.rev frames;;
part_one frames;;
part_two frames;;
