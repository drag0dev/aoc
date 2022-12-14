const std = @import("std");
const ARENA = std.heap.ArenaAllocator;

const Point = struct {x: u32, y: u32, depth: u32};

// NOTE: super slow and a lot of useless allocating but it works

fn appendSet(point: *Point, set: *std.ArrayList(*Point)) !void {
    for (set.*.items) |item| if (item.x == point.*.x and item.y == point.*.y) {return;};
    try set.*.append(point);
}

fn isInSet(point: *Point, set: *std.ArrayList(*Point)) bool {
    for (set.*.items) |item| if (item.x == point.*.x and item.y == point.*.y) return true;
    return false;
}

pub fn main() !void {
    var arena = ARENA.init(std.heap.page_allocator);
    var allocator = arena.allocator();
    defer arena.deinit();

    const file = try std.fs.cwd().openFile("input", std.fs.File.OpenFlags{});
    defer file.close();

    var lineBuffer: []u8 = try allocator.alloc(u8, 1024);
    var bufReader = std.io.bufferedReader(file.reader());
    var inStream = bufReader.reader();

    var lines = std.ArrayList([]u8).init(allocator);

    var temp: []u8 = undefined;
    var i: u32 = 0;
    var j: u32 = undefined;
    var foundStart = false;
    var foundEnd = false;
    var startingCoordinate: [2]u32 = undefined;
    var endingCoordinates: [2]u32 = undefined;

    // load lines
    while (try inStream.readUntilDelimiterOrEof(lineBuffer, '\n')) |line| {
        if (!foundStart) {
            j = 0;
            while (j < line.len) : (j += 1){
                if (line[j] == 'S') {
                    startingCoordinate[0] = i;
                    startingCoordinate[1] = j;
                    line[j] = 'a';
                    foundStart = true;
                    break;
                }
            }
        }
        if(!foundEnd) {
            j = 0;
            while (j < line.len) : (j += 1){
                if (line[j] == 'E') {
                    endingCoordinates[0] = i;
                    endingCoordinates[1] = j;
                    foundEnd = true;
                    line[j] = 'z';
                    break;
                }
            }

        }

        temp = try allocator.alloc(u8, line.len);
        std.mem.copy(u8, temp, line);
        try lines.append(temp);
        i += 1;
    }

    // bfs
    var q = std.TailQueue(*Point){};
    const Node = std.TailQueue(*Point).Node;
    var set = std.ArrayList(*Point).init(allocator);
    var newPoint: *Point = try allocator.create(Point);
    var tempPoint: *Point = undefined;
    var value: u8 = undefined;
    var newNode: *Node = try allocator.create(Node);
    var res: u64 = 10e10;

    i = 0;
    j = 0;
    // part one
    // newPoint.*.x = startingCoordinate[0];
    // newPoint.*.y = startingCoordinate[1];
    // part two
    for (lines.items) |line| {
        j = 0;
        for (line) |char| {
            if (char == 'a') {
                set = std.ArrayList(*Point).init(allocator);
                while(q.len > 0) _ = q.pop();
                newPoint.*.x = i;
                newPoint.*.y = j;
                newPoint.*.depth = 0;
                newNode.*.data = newPoint;
                q.append(newNode);

                while (true){
                    if (q.len == 0) break;
                    tempPoint = q.popFirst().?.*.data;
                    if (!isInSet(tempPoint, &set)) {
                        value = lines.items[tempPoint.*.x][tempPoint.*.y];
                        if (tempPoint.*.x == endingCoordinates[0] and tempPoint.*.y == endingCoordinates[1]) {
                            if (tempPoint.*.depth < res) res = tempPoint.*.depth;
                            break;
                        }
                        try appendSet(tempPoint, &set);

                        // up
                        if (tempPoint.*.x > 0) { if (lines.items[tempPoint.*.x-1][tempPoint.*.y]-1 <= value){
                                newPoint = try allocator.create(Point);
                                newPoint.*.x = tempPoint.*.x-1;
                                newPoint.*.y = tempPoint.*.y;
                                newPoint.*.depth = tempPoint.*.depth+1;
                                newNode = try allocator.create(Node);
                                newNode.*.data = newPoint;
                                q.append(newNode);
                            }
                        }

                        // right
                        if (tempPoint.*.y < lines.items[0].len-1) {
                            if(lines.items[tempPoint.*.x][tempPoint.*.y+1]-1 <= value) {
                                newPoint = try allocator.create(Point);
                                newPoint.*.x = tempPoint.*.x;
                                newPoint.*.y = tempPoint.*.y+1;
                                newPoint.*.depth = tempPoint.*.depth+1;
                                newNode = try allocator.create(Node);
                                newNode.*.data = newPoint;
                                q.append(newNode);
                            }
                        }

                        // down
                        if (tempPoint.*.x < lines.items.len-1) {
                            if (lines.items[tempPoint.*.x+1][tempPoint.*.y]-1 <= value) {
                                newPoint = try allocator.create(Point);
                                newPoint.*.x = tempPoint.*.x+1;
                                newPoint.*.y = tempPoint.*.y;
                                newPoint.*.depth = tempPoint.*.depth+1;
                                newNode = try allocator.create(Node);
                                newNode.*.data = newPoint;
                                q.append(newNode);
                            }
                        }

                        // left
                        if (tempPoint.*.y > 0) {
                            if (lines.items[tempPoint.*.x][tempPoint.*.y-1]-1 <= value) {
                                newPoint = try allocator.create(Point);
                                newPoint.*.x = tempPoint.*.x;
                                newPoint.*.y = tempPoint.*.y-1;
                                newPoint.*.depth = tempPoint.*.depth+1;
                                newNode = try allocator.create(Node);
                                newNode.*.data = newPoint;
                                q.append(newNode);
                            }
                        }
                    }
                }

            }
            j += 1;
        }
        i += 1;
    }

    std.debug.print("res: {}\n", .{res});
}
