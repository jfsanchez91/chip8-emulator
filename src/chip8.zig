const std = @import("std");
const cstd = @cImport(@cInclude("stdlib.h"));
const ctime = @cImport(@cInclude("time.h"));

opcode: u16,
memory: [4096]u8,
screen: [64 * 32]u8,
registers: [16]u8,
index: u16,
program_counter: u16,
delay_timer: u8,
sound_timer: u8,
stack: [16]u16,
sp: u16,

const Self = @This();
pub fn init(self: *Self) void {
    _ = self;
}
