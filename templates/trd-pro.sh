#!/usr/bin/env bash
# Template: trd-pro
# Toyota TRD Pro heritage livery. Red, orange, yellow hockey stick stripes on matte dark.
# Colors from Ivan "Ironman" Stewart's racing legacy.

TEMPLATE_NAME="trd-pro"
TEMPLATE_DESC="TRD Pro heritage stripes. Red, orange, yellow."
BG_TYPE="solid"
BG_COLOR="srgb(32,32,32)"
PADDING=60
CORNER_RADIUS=10
SHADOW_BLUR=22
SHADOW_OFFSET=6
SHADOW_COLOR="rgba(0,0,0,0.5)"

custom_background() {
    local bg_path="$1"
    local out_w="$2"
    local out_h="$3"

    # TRD Heritage tri-color: Red, Orange, Yellow
    local trd_red="srgb(205,35,40)"
    local trd_orange="srgb(230,120,30)"
    local trd_yellow="srgb(240,195,45)"

    # Hockey stick stripes: horizontal run along the bottom, bends up on the right
    local bend_x=$((out_w * 60 / 100))
    local base_y=$((out_h * 70 / 100))

    # Red (thickest — 40px)
    local r_t=40
    local r_y=$((base_y))
    # Orange (medium — 30px)
    local o_t=30
    local o_y=$((r_y + r_t + 10))
    # Yellow (thinnest — 22px)
    local y_t=22
    local y_y=$((o_y + o_t + 10))

    magick -size "${out_w}x${out_h}" "xc:srgb(32,32,32)" -alpha off \
        -fill "${trd_red}" \
        -draw "polygon 0,${r_y} ${bend_x},${r_y} $((out_w)),$((r_y - (out_w - bend_x))) $((out_w)),$((r_y - (out_w - bend_x) - r_t)) $((bend_x)),$((r_y - r_t)) 0,$((r_y - r_t))" \
        \
        -fill "${trd_orange}" \
        -draw "polygon 0,${o_y} ${bend_x},${o_y} $((out_w)),$((o_y - (out_w - bend_x))) $((out_w)),$((o_y - (out_w - bend_x) - o_t)) $((bend_x)),$((o_y - o_t)) 0,$((o_y - o_t))" \
        \
        -fill "${trd_yellow}" \
        -draw "polygon 0,${y_y} ${bend_x},${y_y} $((out_w)),$((y_y - (out_w - bend_x))) $((out_w)),$((y_y - (out_w - bend_x) - y_t)) $((bend_x)),$((y_y - y_t)) 0,$((y_y - y_t))" \
        \
        "$bg_path"
}
