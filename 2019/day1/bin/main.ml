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

let rec map_lines_to_int lines acc = match lines with
    | [] -> acc
    | h :: t ->
            let num = int_of_string h in
            map_lines_to_int t ( num :: acc ) ;;

let map_mass_to_fuel fuel = ( fuel / 3 ) - 2;;

let rec map_mass_to_fuel_part_two_inner fuel acc =
    if fuel <= 0 then
        let new_fuel = if fuel < 0 then -1 * fuel else fuel in
        acc + new_fuel
    else
        let new_fuel = ((fuel / 3) - 2) in
        map_mass_to_fuel_part_two_inner new_fuel (acc + new_fuel);;

let map_mass_to_fuel_part_two fuel = map_mass_to_fuel_part_two_inner fuel 0

let lines = read_lines "input";;
let masses = map_lines_to_int lines [];;

let fuels_part_one = List.map map_mass_to_fuel masses;;
let res_part_one = List.fold_left ( + ) 0 fuels_part_one;;
Printf.printf "Part one: %d\n" res_part_one;;

let fuels_part_two = List.map map_mass_to_fuel_part_two masses;;
let res_part_two = List.fold_left ( + ) 0 fuels_part_two;;
Printf.printf "Part two: %d\n" res_part_two
