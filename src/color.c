#include "color.h"

#include <ncurses.h>

ColorTheme CT_init() {
    short temp_color_index      = CUSTOMIZE_COLOR_START_INDEX;
    short temp_color_pair_index = CUSTOMIZE_COLOR_PAIR_START_INDEX;

    ColorTheme self = (ColorTheme){
        .name = "TronLegacy",
        .pairs =
            {
                (ColorPair){
                    .color_pair_index       = -1,
                    .foreground_color_index = -1,
                    .background_color_index = -1,
                    .name                   = "Tron Red",
                    .foreground =
                        (Color){
                            .r = (float)((float)0xF4 / (float)256) * 1000,
                            .g = (float)((float)0x47 / (float)256) * 1000,
                            .b = (float)((float)0x47 / (float)256) * 1000,
                        },
                    .background =
                        (Color){
                            .r = (float)((float)0x23 / (float)256) * 1000,
                            .g = (float)((float)0x21 / (float)256) * 1000,
                            .b = (float)((float)0x1B / (float)256) * 1000,
                        },
                },
                (ColorPair){
                    .color_pair_index       = -1,
                    .foreground_color_index = -1,
                    .background_color_index = -1,
                    .name                   = "Tron Orange",
                    .foreground =
                        (Color){
                            .r = (float)((float)0xFF / (float)256) * 1000,
                            .g = (float)((float)0x9F / (float)256) * 1000,
                            .b = (float)((float)0x1C / (float)256) * 1000,
                        },
                    .background =
                        (Color){
                            .r = (float)((float)0x23 / (float)256) * 1000,
                            .g = (float)((float)0x21 / (float)256) * 1000,
                            .b = (float)((float)0x1B / (float)256) * 1000,
                        },
                },
                (ColorPair){
                    .color_pair_index       = -1,
                    .foreground_color_index = -1,
                    .background_color_index = -1,
                    .name                   = "Tron Blue",
                    .foreground =
                        (Color){
                            .r = (float)((float)0x6F / (float)256) * 1000,
                            .g = (float)((float)0xC3 / (float)256) * 1000,
                            .b = (float)((float)0xDF / (float)256) * 1000,
                        },
                    .background =
                        (Color){
                            .r = (float)((float)0x23 / (float)256) * 1000,
                            .g = (float)((float)0x21 / (float)256) * 1000,
                            .b = (float)((float)0x1B / (float)256) * 1000,
                        },
                },
                (ColorPair){
                    .color_pair_index       = -1,
                    .foreground_color_index = -1,
                    .background_color_index = -1,
                    .name                   = "Tron Yellow",
                    .foreground =
                        (Color){
                            .r = (float)((float)0xFF / (float)256) * 1000,
                            .g = (float)((float)0xE6 / (float)256) * 1000,
                            .b = (float)((float)0x4D / (float)256) * 1000,
                        },
                    .background =
                        (Color){
                            .r = (float)((float)0x23 / (float)256) * 1000,
                            .g = (float)((float)0x21 / (float)256) * 1000,
                            .b = (float)((float)0x1B / (float)256) * 1000,
                        },
                },
            },
    };

    for (int index = 0; index < COLOR_PAIR_SIZE; index++) {
        //
        // `init_color` creates RGB color
        //
        // init_color(color_index, r, g, b)
        //
        const short foreground_color_index = temp_color_index;
        init_color(foreground_color_index,
                   self.pairs[index].foreground.r,
                   self.pairs[index].foreground.g,
                   self.pairs[index].foreground.b);
        self.pairs[index].foreground_color_index = foreground_color_index;
        temp_color_index += 1;

        const short background_color_index = temp_color_index;
        init_color(background_color_index,
                   self.pairs[index].background.r,
                   self.pairs[index].background.g,
                   self.pairs[index].background.b);
        self.pairs[index].background_color_index = background_color_index;
        temp_color_index += 1;

        //
        // `init_pair` creates foreground and background color pair
        //
        // init_pair(color_pair_index, foreground_color_index, background_color_index)
        //
        init_pair(temp_color_pair_index,
                  foreground_color_index,
                  background_color_index);
        self.pairs[index].color_pair_index = temp_color_pair_index;
        temp_color_pair_index += 1;
    }

    return self;
}
