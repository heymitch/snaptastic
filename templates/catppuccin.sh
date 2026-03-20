#!/usr/bin/env bash
# Template: catppuccin
# Catppuccin Mocha palette. Bold diagonal rainbow stripes — mirrored on both sides.

TEMPLATE_NAME="catppuccin"
TEMPLATE_DESC="Catppuccin Mocha with bold diagonal rainbow stripes"
BG_TYPE="solid"
BG_COLOR="srgb(30,30,46)"
PADDING=60
CORNER_RADIUS=12
SHADOW_BLUR=22
SHADOW_OFFSET=6
SHADOW_COLOR="rgba(0,0,0,0.4)"

custom_background() {
    local bg_path="$1"
    local out_w="$2"
    local out_h="$3"

    local sw=70

    # Left side stripes: top-left to bottom-right (45°)
    # Position so they peek out from behind the screenshot on the left
    local lx=$(( (out_w - out_h) / 2 - sw * 3 ))

    # Right side stripes: mirrored — top-right to bottom-left
    # These go the opposite direction
    local rx=$(( out_w - (out_w - out_h) / 2 + sw * 3 ))

    magick -size "${out_w}x${out_h}" "xc:srgb(30,30,46)" -alpha off \
        \
        -fill "srgb(203,166,247)" \
        -draw "polygon $((rx-sw*6)),0 $((rx-sw*5)),0 $((rx-sw*5-out_h)),${out_h} $((rx-sw*6-out_h)),${out_h}" \
        -fill "srgb(137,220,235)" \
        -draw "polygon $((rx-sw*5)),0 $((rx-sw*4)),0 $((rx-sw*4-out_h)),${out_h} $((rx-sw*5-out_h)),${out_h}" \
        -fill "srgb(166,227,161)" \
        -draw "polygon $((rx-sw*4)),0 $((rx-sw*3)),0 $((rx-sw*3-out_h)),${out_h} $((rx-sw*4-out_h)),${out_h}" \
        -fill "srgb(249,226,175)" \
        -draw "polygon $((rx-sw*3)),0 $((rx-sw*2)),0 $((rx-sw*2-out_h)),${out_h} $((rx-sw*3-out_h)),${out_h}" \
        -fill "srgb(250,179,135)" \
        -draw "polygon $((rx-sw*2)),0 $((rx-sw)),0 $((rx-sw-out_h)),${out_h} $((rx-sw*2-out_h)),${out_h}" \
        -fill "srgb(245,194,231)" \
        -draw "polygon $((rx-sw)),0 ${rx},0 $((rx-out_h)),${out_h} $((rx-sw-out_h)),${out_h}" \
        \
        "$bg_path"
}
