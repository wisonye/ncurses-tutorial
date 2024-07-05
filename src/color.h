#include <ncurses.h>

#define COLOR_PAIR_SIZE 10
#define CUSTOMIZE_COLOR_START_INDEX 9
#define CUSTOMIZE_COLOR_PAIR_START_INDEX 1

// `NCURSES_COLOR_T` -> `short`

typedef struct Color {
    NCURSES_COLOR_T r;
    NCURSES_COLOR_T g;
    NCURSES_COLOR_T b;
} Color;

typedef struct ColorPair {
    // This usesd for `init_pair`
    NCURSES_COLOR_T color_pair_index;
    // Not useful, just for debugging
    NCURSES_COLOR_T foreground_color_index;
    NCURSES_COLOR_T background_color_index;

    const char *name;
    Color foreground;
    Color background;
} ColorPair;

typedef struct ColorTheme {
    const char *name;
    ColorPair pairs[COLOR_PAIR_SIZE];

} ColorTheme;

ColorTheme CT_init();
