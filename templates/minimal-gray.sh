#!/usr/bin/env bash
# Template: minimal-gray
# Light gray background with blocky geometric accents. Maximum restraint.

TEMPLATE_NAME="minimal-gray"
TEMPLATE_DESC="Neutral gray with blocky geometric accents"
BG_TYPE="solid"
BG_COLOR="srgb(235,235,235)"
PADDING=48
CORNER_RADIUS=8
SHADOW_BLUR=16
SHADOW_OFFSET=4
SHADOW_COLOR="rgba(0,0,0,0.12)"

custom_background() {
    local bg_path="$1"
    local out_w="$2"
    local out_h="$3"

    magick -size "${out_w}x${out_h}" "xc:srgb(235,235,235)" -alpha off \
        -fill "srgb(215,215,218)" \
        -draw "rectangle 0,0 $((out_w/6)),$((out_h/5))" \
        -fill "srgb(220,220,225)" \
        -draw "rectangle $((out_w*5/6)),$((out_h*4/5)) ${out_w},${out_h}" \
        -fill "srgb(225,225,228)" \
        -draw "rectangle $((out_w*3/7)),0 $((out_w*3/7+40)),12" \
        -fill "srgb(210,210,215)" \
        -draw "rectangle $((out_w-60)),$((out_h/3)) ${out_w},$((out_h/3+80))" \
        -fill "srgb(218,218,222)" \
        -draw "rectangle 0,$((out_h*2/3)) 30,$((out_h*2/3+50))" \
        "$bg_path"
}
