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

let extract_numbers str =
    let pattern = Re.Perl.compile_pat "\\d+" in
    let found_parts = Re.all pattern str in
    let parts = List.map (fun part -> Re.Group.get part 0) found_parts in
    let parts = List.map int_of_string parts in
    match parts with
    | one :: two :: three :: four :: five :: [] -> (one,two, three, four, five)
    | _ -> assert false;;

let rec map_line_numbers lines acc =
    match lines with
    | [] -> List.rev acc
    | h :: t ->
            let (idx, start_x, start_y, x_dimension, y_dimension) = h in
            let tuple = (idx, (start_x, start_y), (start_x+x_dimension, start_y+y_dimension)) in
            let acc = tuple :: acc in
            map_line_numbers t acc;;

module PointSet = Set.Make(struct
  type t = int * int
  let compare (x1, y1) (x2, y2) =
    match compare x1 x2 with
    | 0 -> compare y1 y2
    | c -> c
end)

let rec generate_plot_points x y start_x end_x end_y points duplicate_points =
    match y >= end_y with
    | true -> (points, duplicate_points)
    | false ->
            let (new_x, new_y) = match x = ( end_x - 1) with
            | false -> ((x + 1), y)
            | true -> (start_x, (y+1)) in

            let (points, duplicate_points) = match PointSet.find_opt (x, y) points with
                | None ->
                        let points = PointSet.add (x, y) points in
                        (points, duplicate_points)
                | Some _ ->
                        let duplicate_points = PointSet.add (x, y) duplicate_points in
                        (points, duplicate_points) in
            generate_plot_points new_x new_y start_x end_x end_y points duplicate_points;;

let rec generate_all_points plots points duplicate_points =
    match plots with
    | [] -> (points, duplicate_points)
    | h :: t ->
            let (_, (start_x, start_y), (end_x, end_y)) = h in
            let (points, acc) = generate_plot_points start_x start_y start_x end_x end_y points duplicate_points in
            generate_all_points t points acc;;

let rec check_if_all_points_unique x y start_x end_x end_y duplicate_points =
    match y >= end_y with
    | true -> true
    | false ->
            let (new_x, new_y) = match x = ( end_x - 1) with
            | false -> ((x + 1), y)
            | true -> (start_x, (y+1)) in

            match PointSet.find_opt (x,y) duplicate_points with
            | Some _ -> false
            | None -> check_if_all_points_unique new_x new_y start_x end_x end_y duplicate_points;;

let rec find_intact plots duplicate_points =
    match plots with
    | [] -> assert false
    | h :: t ->
            let (idx, (start_x, start_y), (end_x, end_y)) = h in
            match check_if_all_points_unique start_x start_y start_x end_x end_y duplicate_points with
            | true -> idx
            | false -> find_intact t duplicate_points;;

let part_one plots =
    let (_, duplicate_points) = generate_all_points plots PointSet.empty PointSet.empty in
    let duplicate_points = PointSet.to_list duplicate_points |> List.length in
    Printf.printf "Part one: %d\n" duplicate_points;;

let part_two plots =
    let (_, duplicate_points) = generate_all_points plots PointSet.empty PointSet.empty in
    let non_overlap_idx = find_intact plots duplicate_points in
    Printf.printf "Part two: %d\n" non_overlap_idx;;

let lines = read_lines "input";;
let lines = List.map (fun line -> extract_numbers line) lines;;
let lines = List.rev lines;;
let plots = map_line_numbers lines [];;
part_one plots;;
part_two plots;;
