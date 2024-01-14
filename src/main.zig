const std = @import("std");
const c = @cImport({
    @cInclude("SDL2/SDL.h");
});
const CHIP8 = @import("chip8.zig");

var window: ?*c.SDL_Window = null;
var renderer: ?*c.SDL_Renderer = null;
var texture: ?*c.SDL_Texture = null;

const WINDOW_HEIGHT = 600;
const WINDOW_WIDTH = 800;

var cpu: *CHIP8 = undefined;

pub fn init() !void {
    if (c.SDL_Init(c.SDL_INIT_VIDEO) < 0) {
        @panic("SDL ERROR: SDL Initialization failed.");
    }
    window = c.SDL_CreateWindow("chip8-emulator", 0, 0, WINDOW_HEIGHT, WINDOW_WIDTH, c.SDL_WINDOW_SHOWN);
    if (window == null) {
        @panic("SDL ERROR: Window initialization failed.");
    }

    renderer = c.SDL_CreateRenderer(window, -1, 0);
    if (renderer == null) {
        @panic("SDL ERROR: Renderer initialization failed.");
    }

    texture = c.SDL_CreateTexture(renderer, c.SDL_PIXELFORMAT_ABGR8888, c.SDL_TEXTUREACCESS_STREAMING, 64, 32);
    if (texture == null) {
        @panic("SDL ERROR: Texture initialization failed.");
    }
}

pub fn deinit() void {
    c.SDL_DestroyWindow(window);
    c.SDL_Quit();
}

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();

    init();
    defer deinit();

    cpu = try allocator.create(CHIP8);
    cpu.init();

    var quit = false;
    while (!quit) {
        var event: c.SDL_Event = undefined;
        while (c.SDL_PollEvent(&event)) {
            switch (event.type) {
                c.SDL_QUIT => quit = true,
                else => {},
            }
        }

        _ = c.SDL_RenderClear(renderer);
        _ = c.SDL_RenderCopy(renderer, texture, null, null);
        _ = c.SDL_RenderPresent(renderer);
        std.time.sleep(16 * 1000 * 1000);
    }
}
