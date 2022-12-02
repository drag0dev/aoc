const std = @import("std");
const GPA = std.heap.GeneralPurposeAllocator;
const ArrayList = std.ArrayList;

const Play = struct {
    playerPlay: u8,
    enemyPlay: u8
};

pub fn main() !void {
    var gpa = GPA(.{}){};
    const allocator = gpa.allocator();
    defer {
        const leaked = gpa.deinit();
        if (leaked) std.debug.print("leaking", .{});
    }

    var plays = ArrayList(Play).init(allocator);
    defer plays.deinit();

    const file = try std.fs.cwd().openFile("./input", std.fs.File.OpenFlags{});
    defer file.close();

    var lineBuf: [1024]u8 = undefined;
    var bufReader = std.io.bufferedReader(file.reader());
    var inStream = bufReader.reader();
    var number_of_plays: u64 = 0;
    while (try inStream.readUntilDelimiterOrEof(&lineBuf, '\n')) |line| {
        try plays.append(Play{
            .enemyPlay = line[0],
            .playerPlay = line[2]
        });
        number_of_plays += 1;
    }

    var score_one: u64 = 0;
    var score_two: u64 = 0;
    var play: Play = undefined;
    while (number_of_plays > 0){
        play = plays.pop();

        // part one
        // tie
        if (play.playerPlay-23 == play.enemyPlay) {score_one += 3 + play.playerPlay-64-23;}

        // losing
        else if (play.playerPlay == 'X' and play.enemyPlay == 'B') {score_one += 1;}
        else if (play.playerPlay == 'Y' and play.enemyPlay == 'C') {score_one += 2;}
        else if (play.playerPlay == 'Z' and play.enemyPlay == 'A') {score_one += 3;}

        // winning
        else if (play.playerPlay == 'Y' and play.enemyPlay == 'A') {score_one += 8;}
        else if (play.playerPlay == 'Z' and play.enemyPlay == 'B') {score_one += 9;}
        else if (play.playerPlay == 'X' and play.enemyPlay == 'C') {score_one += 7;}

        // part two
        if (play.playerPlay == 'X') { // lose
            if (play.enemyPlay == 'A') score_two += 3;
            if (play.enemyPlay == 'B') score_two += 1;
            if (play.enemyPlay == 'C') score_two += 2;
        }else if (play.playerPlay == 'Y') { // draw
            score_two += play.enemyPlay-64 + 3;
        }else { // win
            if (play.enemyPlay == 'A') score_two += 8;
            if (play.enemyPlay == 'B') score_two += 9;
            if (play.enemyPlay == 'C') score_two += 7;
        }

        number_of_plays -= 1;
    }

    std.debug.print("Part one: {}\n", .{score_one});
    std.debug.print("Part two: {}\n", .{score_two});
}
