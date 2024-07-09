//
// Popup window
//
export type PopupWindow = struct {
	win: const nullable *WINDOW,
	left: size,
	top: size,
	width: size,
	height: size,
};

export fn create_popup_window(
	left: size,
	top: size,
	width: size,
	height: size,
	with_default_border: bool) PopupWindow = {
	let w = PopupWindow {
		left   = left,
		top    = top,
		width  = width,
		height = height,
		win    = null,
	};
	w.win = newwin( w.height: int, w.width: int, w.top: int, w.left: int);
	wrefresh(stdscr);

	// Draw a box with default border to the given window (area)
	if (with_default_border) {
		box(w.win, 0, 0);
		wrefresh(w.win);
	};

	return w;
};
