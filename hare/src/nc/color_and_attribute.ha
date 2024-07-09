export def NCURSES_ATTR_SHIFT: u32 = 8;

//
// Predefined attributes
//
export def A_COLOR: u32 = 65280;
export def A_ATTRIBUTES: u32 = 4294967040;
export def A_NORMAL: u32 = 0;
export def A_STANDOUT: u32 = 65536;
export def A_UNDERLINE: u32 = 131072;
export def A_REVERSE: u32 = 262144;
export def A_BLINK: u32 = 524288;
export def A_DIM: u32 = 1048576;
export def A_BOLD: u32 = 2097152;
export def A_ALTCHARSET: u32 = 4194304;
export def A_INVIS: u32 = 8388608;
export def A_PROTECT: u32 = 16777216;
export def A_HORIZONTAL: u32 = 33554432;
export def A_LEFT: u32 = 67108864;
export def A_LOW: u32 = 134217728;
export def A_RIGHT: u32 = 268435456;
export def A_TOP: u32 = 536870912;
export def A_VERTICAL: u32 = 1073741824;
export def A_ITALIC: u32 = 2147483648;

//
// Predefined colors
//
export def COLOR_BLACK: u16 = 0;
export def COLOR_RED: u16 = 1;
export def COLOR_GREEN: u16 = 2;
export def COLOR_YELLOW: u16 = 3;
export def COLOR_BLUE: u16 = 4;
export def COLOR_MAGENTA: u16 = 5;
export def COLOR_CYAN: u16 = 6;
export def COLOR_WHITE: u16 = 7;

//
// Predefined types
//
export type Color = u16;
export type ColorIndex = u16;
export type ColorPair = u16;
export type ColorPairIndex = u16;
export type VideoAttr = u32;

//
// Check and enable colors
//
export @symbol("has_colors") fn has_colors() bool;
export @symbol("can_change_color") fn can_change_color() bool;
export @symbol("start_color") fn start_color() int;

//
// Define and use color and color pairs (foregroud <-> background)
//
export @symbol("init_color") fn init_color(
	index: ColorIndex,
	r: Color,
	g: Color,
	b: Color) int;

export @symbol("init_pair") fn init_pair(
	index: ColorPairIndex,
	foreground_color_index: ColorIndex,
	background_color_index: ColorIndex) int;

export fn color_pair(index: ColorPairIndex) VideoAttr = {
	return ((index << (0 + NCURSES_ATTR_SHIFT)) & A_COLOR);
};

//
// Enable or disable (video) attributes
//
@symbol("wattr_on") fn _wattr_on(
	win: nullable *WINDOW,
	attr: VideoAttr,
	not_use: nullable *opaque) int;
export fn wattr_on(win: nullable *WINDOW, attr: VideoAttr) int = {
	return _wattr_on(win, attr, null);
};

@symbol("wattr_off") fn _wattr_off(
	win: nullable *WINDOW,
	attr: VideoAttr,
	not_use: nullable *opaque) int;
export fn wattr_off(win: nullable *WINDOW, attr: VideoAttr) int = {
	return _wattr_off(win, attr, null);
};

