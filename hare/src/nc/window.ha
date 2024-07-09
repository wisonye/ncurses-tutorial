//
// Create and destroy
//
export @symbol("newwin") fn newwin(
	height: int,
	width: int,
	left: int,
	top: int) *WINDOW;
export @symbol("delwin") fn delwin(win: nullable *WINDOW) int;
export @symbol("endwin") fn endwin() int;

//
// Size and rect
//
export type WindowSize = struct {
	width: int,
	height: int,
};

export fn get_window_size(win: const nullable *WINDOW) WindowSize = {
	return WindowSize {
		width = getmaxx(win),
		height = getmaxy(win),
	};
};

export type WindowRect = struct {
	left: int,
	top: int,
	right: int,
	bottom: int,
	width: int,
	height: int,
};

export fn get_window_rect(win: const nullable *WINDOW) WindowRect = {
	const left = getbegx(win);
	const top = getbegy(win);
	const width = getmaxx(win);
	const height = getmaxy(win);
	
	return WindowRect {
		left = left,
		top = top,
		right = left + width,
		bottom = top + height,
		width = width,
		height = height,
	};
};

