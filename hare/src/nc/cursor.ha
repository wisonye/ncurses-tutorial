use types::c;

//
// Cursor option
//
export def CURSOR_INVISIBLE: int = 0;
export def CURSOR_NORMAL: int = 1;
export def CURSOR_VERY_VISIBLE: int = 2;

@symbol("curs_set") fn curs_set(int) int;
export fn hide_cursor() int = curs_set(CURSOR_INVISIBLE);
export fn show_cursor() int = curs_set(CURSOR_NORMAL);
export fn show_cursor_2() int = curs_set(CURSOR_VERY_VISIBLE);

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
export @symbol("wmove") fn wmove(win: nullable *WINDOW, y: int, x: int) int;
export fn set_cursor_position(win: const nullable *WINDOW,pos: *CursorPosition) int = {
	return wmove(win, pos.y, pos.x);
};

