const std = @import("std");
const abs = std.math.absCast;
const ARENA = std.heap.ArenaAllocator;
const Allocator = std.mem.Allocator;

fn addPoint(x: i64, y: i64, set: *std.ArrayList(*Point), allocator: Allocator) !void {
    var found = false;
    for (set.*.items) |point|{
        if (point.x == x and point.y == y) {
            found = true;
            break;
        }
    }
    if (!found) {
        var temp = try allocator.create(Point);
        temp.*.x = x;
        temp.*.y = y;
        try set.*.append(temp);
    }
}

fn move(head: *Point, tail: *Point) void {
    var colDiff: i64 = head.*.x - tail.*.x;
    var rowDiff: i64 = head.*.y - tail.*.y;
    if (abs(colDiff) <= 1 and abs(rowDiff) <= 1) return;

    if (tail.*.x == head.*.x) { // same col
        if (head.*.y > tail.*.y) { tail.*.y += 1; }
        else { tail.*.y -= 1; }
    }
    else if (tail.*.y == head.*.y) { // same row
        if (head.*.x > tail.*.x) { tail.*.x += 1; }
        else { tail.*.x -= 1; }
    }
    else if (head.*.x > tail.*.x and head.*.y > tail.*.y) { // upper right
        tail.*.x += 1;
        tail.*.y += 1;
    }
    else if (head.*.x > tail.*.x and head.*.y < tail.*.y) { // bottom right
        tail.*.x += 1;
        tail.*.y -= 1;
    }
    else if (head.*.x < tail.*.x and head.*.y < tail.*.y) { // bottom left
        tail.*.x -= 1;
        tail.*.y -= 1;
    }
    else if (head.*.x < tail.*.x and head.*.y > tail.*.y) { // top left
        tail.*.x -= 1;
        tail.*.y += 1;
    }
}

fn parseNum(input: []u8) u64 {
    var res: u64 = 0;
    for (input) |char| {
        res *= 10;
        res += char - 48;
    }
    return res;
}

const Point = struct {
    x: i64,
    y: i64
};

pub fn main() !void {
    const file = try std.fs.cwd().openFile("input", std.fs.File.OpenFlags{});
    defer file.close();

    var arena = ARENA.init(std.heap.page_allocator);
    const allocator = arena.allocator();
    defer arena.deinit();
    var lineBuff: [1024]u8 = undefined;
    var bufferedReader = std.io.bufferedReader(file.reader());
    var inStream = bufferedReader.reader();

    var pointsPartOne = std.ArrayList(*Point).init(allocator);
    var pointsPartTwo = std.ArrayList(*Point).init(allocator);

    var i: u64 = 0;
    var j: u64 = undefined;

    // part part
    var ropeKnots: [10]Point = undefined;
    while (i < 10) {
        ropeKnots[i].x = 0;
        ropeKnots[i].y = 0;
        i += 1;
    }

    while (try inStream.readUntilDelimiterOrEof(&lineBuff, '\n')) |line| {
        i = parseNum(line[2..]);
        while (i > 0) {
            // move head
            if (line[0] == 'R') {ropeKnots[0].x += 1;}
            else if (line[0] == 'L') {ropeKnots[0].x -= 1;}
            else if (line[0] == 'U') {ropeKnots[0].y += 1;}
            else if (line[0] == 'D') {ropeKnots[0].y -= 1;}

            // move rest of the rope
            j = 0;
            while (j < 9) {
                move(&ropeKnots[j], &ropeKnots[j+1]);
                j += 1;
            }

            try addPoint(ropeKnots[1].x, ropeKnots[1].y, &pointsPartOne, allocator);
            try addPoint(ropeKnots[9].x, ropeKnots[9].y, &pointsPartTwo, allocator);
            i -= 1;
        }
    }
    std.debug.print("Part one: {}\n", .{pointsPartOne.items.len});
    std.debug.print("Part two: {}\n", .{pointsPartTwo.items.len});
}
