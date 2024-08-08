use types::c;

//
// Locale related
//
export def LC_CTYPE: int = 0;
export def LC_NUMERIC: int = 1;
export def LC_TIME: int = 2;
export def LC_COLLATE: int = 3;
export def LC_MONETARY: int = 4;
export def LC_MESSAGES: int = 5;
export def LC_ALL: int = 6;
export def LC_PAPER: int = 7;
export def LC_NAME: int = 8;
export def LC_ADDRESS: int =	9;
export def LC_TELEPHONE: int = 10;
export def LC_MEASUREMENT: int = 11;
export def LC_IDENTIFICATION: int = 12;
export @symbol("setlocale") fn setlocale(category: int, locale: const *c::char) *c::char;
