const std = @import("std");
const backend = @import("../backend.zig");

/// Button flat peer
pub const FlatButton = struct {
    peer: backend.PeerType,
    canvas: backend.Canvas,

    label: [:0]const u8 = "",

    pub usingnamespace backend.Events(FlatButton);

    pub fn create() !FlatButton {
        const canvas = try backend.Canvas.create();
        const events = backend.getEventUserData(canvas.peer);
        events.class.drawHandler = draw;

        return FlatButton{ .peer = canvas.peer, .canvas = canvas };
    }

    // TODO: themes and custom styling
    fn draw(ctx: *backend.Canvas.DrawContext, data: usize) void {
        const events = @intToPtr(*backend.EventUserData, data);
        const selfPtr = @intToPtr(?*FlatButton, events.classUserdata);

        const width = @intCast(u32, backend.getWidthFromPeer(events.peer));
        const height = @intCast(u32, backend.getHeightFromPeer(events.peer));

        ctx.setColor(0.3, 0.3, 0.3);
        ctx.rectangle(0, 0, width, height);
        ctx.fill();

        const text = if (selfPtr) |self| self.label else "";
        var layout = backend.Canvas.DrawContext.TextLayout.init();
        defer layout.deinit();
        ctx.setColor(1, 1, 1);
        layout.setFont(.{ .face = "serif", .size = 12.0 });
        ctx.text(0, 0, layout, text);
        ctx.fill();
    }

    pub fn setLabel(self: *FlatButton, label: [:0]const u8) void {
        self.label = label;
        const events = backend.getEventUserData(self.peer);
        events.classUserdata = @ptrToInt(self);
        self.requestDraw() catch {};
    }

    pub fn getLabel(self: *const FlatButton) [:0]const u8 {
        return self.label;
    }
};
