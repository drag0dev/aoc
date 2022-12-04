const std = @import("std");

fn parsePair(input: []u8, res: *[2][2]u8) void {
    var i: u64 = 0; // pair
    var j: u64 = 0; // range
    var temp: u8 = 0;
    for (input) |char|{
        if (char == ',') {
            res[i][j] = temp;
            i += 1;
            j = 0;
            temp = 0;
            continue;
        }
        if (char == '-'){
            res[i][j] = temp;
            j += 1;
            temp = 0;
            continue;
        }

        temp *= 10;
        temp += char - 48;
    }
    res[i][j] = temp;
}

pub fn main() !void {
    const file = try std.fs.cwd().openFile("./input", std.fs.File.OpenFlags{});
    defer file.close();

    var lineBuf: [1024]u8 = undefined;
    var bufReader = std.io.bufferedReader(file.reader());
    var inStream = bufReader.reader();
    var partOne: u64 = 0;
    var partTwo: u64 = 0;
    var pair: [2][2]u8 = undefined;

    while (try inStream.readUntilDelimiterOrEof(&lineBuf, '\n')) |line|{
        parsePair(line, &pair);

        // part one
        if (pair[0][0] <= pair[1][0] and pair[0][1] >= pair[1][1]) {partOne += 1;}
        else if (pair[1][0] <= pair[0][0] and pair[1][1] >= pair[0][1]) {partOne += 1;}

        // part two
        if (pair[0][0] <= pair[1][1] and pair[0][1] >= pair[1][0]) partTwo += 1;
    }

    std.debug.print("Part one: {}\n", .{partOne});
    std.debug.print("Part two: {}\n", .{partTwo});
}
