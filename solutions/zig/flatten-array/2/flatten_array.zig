const std = @import("std");
const mem = std.mem;

pub const Box = union(enum) {
    none,
    one: i12,
    many: []const Box,
};

pub fn flatten(allocator: mem.Allocator, box: Box) mem.Allocator.Error![]i12 {
    var buff = std.ArrayList(i12).empty;
    errdefer {
        buff.deinit(allocator);
    }
    try flattenImpl(allocator, &buff, box);
    return buff.toOwnedSlice(allocator);
}

fn flattenImpl(allocator: mem.Allocator, buff: *std.ArrayList(i12), box: Box) !void {
    switch (box) {
        .none => {},
        .one => |int| {
            try buff.append(allocator, int);
        },
        .many => |many| {
            for (many) |b| {
                try flattenImpl(allocator, buff, b);
            }
        }
    }
}
