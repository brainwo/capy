const std = @import("std");
const backend = @import("backend.zig");

pub const DrawContext = backend.Canvas.DrawContext;

pub const Canvas_Impl = struct {
    pub usingnamespace @import("events.zig").Events(Canvas_Impl);

    peer: ?backend.Canvas = null,
    handlers: Canvas_Impl.Handlers = undefined,

    pub fn init() Canvas_Impl {
        return Canvas_Impl.init_events(Canvas_Impl {});
    }

    pub fn show(self: *Canvas_Impl) !void {
        if (self.peer == null) {
            self.peer = try backend.Canvas.create();
            try self.show_events();
        }
    }
};

pub fn Canvas(config: struct {
    onclick: ?Canvas_Impl.Callback = null
}) Canvas_Impl {
    var btn = Canvas_Impl.init();
    if (config.onclick) |onclick| {
        btn.addClickHandler(onclick) catch unreachable; // TODO: improve
    }
    return btn;
}