use types::c;

//
// Get x,y related
//
@symbol ("getattrs") fn getattrs(win: nullable *WINDOW) int;
@symbol ("getcurx") fn getcurx(win: nullable *WINDOW) int;
@symbol ("getcury") fn getcury(win: nullable *WINDOW) int;
@symbol ("getbegx") fn getbegx(win: nullable *WINDOW) int;
@symbol ("getbegy") fn getbegy(win: nullable *WINDOW) int;
@symbol ("getmaxx") fn getmaxx(win: nullable *WINDOW) int;
@symbol ("getmaxy") fn getmaxy(win: nullable *WINDOW) int;
@symbol ("getparx") fn getparx(win: nullable *WINDOW) int;
@symbol ("getpary") fn getpary(win: nullable *WINDOW) int;

export type CursorPosition = struct { x: int, y: int };
export fn get_cursor_position(win: const nullable *WINDOW) CursorPosition = {
	return CursorPosition { x = getcury(win), y = getcury(win) };
};

//
// Move cursor related
//
@symbol("wmove") fn wmove(win: const nullable *WINDOW, y: int, x: int) int;
export fn move(win: const nullable *WINDOW,pos: *CursorPosition) int = {
	return wmove(win, pos.y, pos.x);
};

