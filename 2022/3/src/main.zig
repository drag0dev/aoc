const std = @import("std");

fn copyLine(src: []u8, dest: []u8) void{
    for (src) |b, i|{
        if (b == 0 or b == '\n') {
            dest[i] = 0;
            break;
        }
        dest[i] = b;
    }
}

pub fn main() !void {
    const file = try std.fs.cwd().openFile("./input", std.fs.File.OpenFlags{});
    defer file.close();

    var lineBuf: [1024]u8 = undefined;
    var bufReader = std.io.bufferedReader(file.reader());
    var inStream = bufReader.reader();

    var group: [3][1024]u8 = undefined;
    var group_count: u64 = 0;
    var i: u64 = 0;
    var j: u64 = 0;
    var found = false;

    var partOne: u64 = 0;
    var partTwo: u64 = 0;
    while (try inStream.readUntilDelimiterOrEof(&lineBuf, '\n')) |line|{
        var len = line.len;
        i = 0;
        j = 0;
        found = false;
        while (i < len/2){
            j = len/2;

            // part one
            while (j < len){
                if (line[i] == line[j]){
                    if (line[i] <= 90) { // uppercase
                        partOne += line[i] - 38;
                    }
                    else { // lowecase
                        partOne += line[i] - 96;
                    }
                    found = true;
                    break;
                }
                j += 1;
            }

            if (found) break;
            i += 1;
        }

        // part two
        if (group_count < 3) {
            copyLine(&lineBuf, &group[group_count]);
            group_count += 1;
        }
        if (group_count == 3){
            var letter: u8 = undefined;
            j = 0;
            i = 0;
            while (group[0][i] != 0 and i < group[0].len){
                letter = group[0][i];
                found = false;
                j = 0;

                // check second line
                while (group[1][j] != 0 and j < group[1].len){
                    if (group[1][j] == letter){
                        found = true;
                        break;
                    }
                    j += 1;
                }

                if (!found) { // if the letter wasnt found in second line
                    i += 1;
                    continue;
                }

                // check third line
                j = 0;
                found = false;
                while (group[2][j] != 0 and j < group[2].len){
                    if (group[2][j] == letter){
                        found = true;
                        break;
                    }
                    j += 1;
                }

                if (found) break;
                i += 1;
            }

            if (letter <= 90) { // uppercase
                partTwo += letter - 38;
            }
            else { // lowecase
                partTwo += letter - 96;
            }

            group_count = 0;
        }
    }
    std.debug.print("Part one: {}\n", .{partOne});
    std.debug.print("Part two: {}\n", .{partTwo});
}
