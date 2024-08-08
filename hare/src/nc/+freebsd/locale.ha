use types::c;

//
// Locale related
//
export def LC_ALL: int = 0;
export def LC_COLLATE: int = 1;
export def LC_CTYPE: int = 2;
export def LC_MONETARY: int = 3;
export def LC_NUMERIC: int = 4;
export def LC_TIME: int = 5;
export def LC_MESSAGES: int = 6;
export @symbol("setlocale") fn setlocale(category: int, locale: const *c::char) *c::char;
