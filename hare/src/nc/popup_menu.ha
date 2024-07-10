//
// Popup menu item
//
export type PopupMenuItem = struct {
	title: str,
};

export type OnMenuItemClick = *fn(*const PopupMenuItem) void;

//
// Popup menu
//
export type PopupMenu = struct {
	win: const nullable *WINDOW,
	left: size,
	top: size,
	width: size,
	height: size,
	items: []PopupMenuItem,
	on_item_click: OnMenuItemClick,
};

export fn init_popup_menu(
	left: size,
	top: size,
	width: size,
	height: size,
	items: []PopupMenuItem,
	on_item_click: OnMenuItemClick,
	with_default_border: bool) PopupMenu = {

	const item_len = len(items);
	let self = PopupMenu {
		left   = left,
		top    = top,
		width  = width,
		height = height,
		// items  = alloc([], item_len),
		items  = items,
		on_item_click = on_item_click,
		win    = null,
	};

	// //
	// // Copy items (allocated on the heap)
	// //
	// for( let index=0z; index < item_len; index +=1) {
	// 	self.items[index] = items[index];
	// };

	self.win = newwin( self.height: int, self.width: int, self.top: int, self.left: int);
	wrefresh(stdscr);

	// Draw a box with default border to the given window (area)
	if (with_default_border) {
		box(self.win, 0, 0);
		wrefresh(self.win);
	};

	return self;
};

export fn deinit_popup_menu(self: *PopupMenu) void = {
	if (self.win != null) {
		delwin(self.win);
		self.win = null;
	};
	// free(self.items);
};
