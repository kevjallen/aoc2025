const std = @import("std");

pub const SecurityDial = struct {
    current_pos: u8 = 50,

    pub const dialSize: u8 = 100;

    pub fn rotate(self: *SecurityDial, instruction: []const u8) !u8 {
        if (instruction.len < 2) {
            return error.InvalidInstruction;
        }

        const direction: u8 = instruction[0];
        const raw_steps = try std.fmt.parseInt(usize, instruction[1..], 10);
        const steps: u8 = @intCast(raw_steps % dialSize);

        switch (direction) {
            'L' => {
                self.current_pos = (self.current_pos + dialSize - steps) % dialSize;
            },
            'R' => {
                self.current_pos = (self.current_pos + steps) % dialSize;
            },
            else => return error.InvalidInstruction,
        }
        return self.current_pos;
    }
};

pub fn solve(input: []const u8) !void {
    var dial = SecurityDial{};
    var iter = std.mem.tokenizeScalar(u8, input, '\n');
    var counter: usize = 0;

    var position: u8 = undefined;
    while (iter.next()) |instruction| {
        position = try dial.rotate(instruction);
        if (position == 0) {
            counter += 1;
        }
    }
    std.debug.print("Number of times dial returned to 0: {}\n", .{counter});
}

