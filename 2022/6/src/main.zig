const std = @import("std");

fn checkGivenRange(buf: []u8) bool {
    var i: u64 = 0;
    var j: u64 = undefined;
    var found: bool = undefined;
    while (i < buf.len){
        j = 0;
        found = false;
        while (j < buf.len){
            if (j != i and buf[j] == buf[i]){
                found = true;
                break;
            }
            j += 1;
        }
        if (found) return false;
        i += 1;
    }
    return true;
}

pub fn main() !void {
    const file = try std.fs.cwd().openFile("./input", std.fs.File.OpenFlags{});
    defer file.close();

    var partOne: u64 = 4;
    var partTwo: u64 = 14;
    var partOneDone: bool = false;
    var partTwoDone: bool = false;

    var lineBuf: [4096]u8 = undefined;
    var bufReader = std.io.bufferedReader(file.reader());
    var inStream = bufReader.reader();

    var startIndexOne: u64 = 0;
    var endIndexOne: u64 = 3;
    var startIndexTwo: u64 = 0;
    var endIndexTwo: u64 = 13;

    var line = (try inStream.readUntilDelimiterOrEof(&lineBuf, '\n')).?;

    while (startIndexOne < line.len and startIndexTwo < line.len and (!partOneDone or !partTwoDone)) {
        // part one
        if (!partOneDone){
            if (checkGivenRange(line[startIndexOne..endIndexOne+1])){
                partOneDone = true;
            }else{
                startIndexOne += 1;
                endIndexOne += 1;
                partOne += 1;
            }
        }

        // part two
        if(!partTwoDone){
            if (checkGivenRange(line[startIndexTwo..endIndexTwo+1])){
                partTwoDone = true;
            }else{
                startIndexTwo += 1;
                endIndexTwo += 1;
                partTwo += 1;
            }
        }
    }

    std.debug.print("Part one: {}\n", .{partOne});
    std.debug.print("Part two: {}\n", .{partTwo});
}
