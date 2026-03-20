#!/usr/bin/env bash
# Template: synthwave
# Synthwave/retrowave. Deep purple gradient with perspective grid and horizon glow.

TEMPLATE_NAME="synthwave"
TEMPLATE_DESC="Retrowave gradient with grid horizon"
BG_TYPE="gradient"
BG_GRADIENT_TOP="srgb(15,5,35)"
BG_GRADIENT_BOT="srgb(30,10,60)"
PADDING=60
CORNER_RADIUS=14
SHADOW_BLUR=28
SHADOW_OFFSET=6
SHADOW_COLOR="srgb(80,20,120)"

custom_background() {
    local bg_path="$1"
    local out_w="$2"
    local out_h="$3"

    local horizon_y=$(( out_h * 2 / 3 ))
    local grid_color="srgb(120,40,180)"
    local glow_pink="srgb(255,45,149)"
    local glow_cyan="srgb(0,200,255)"

    # Vanishing point at center of horizon
    local vp_x=$((out_w / 2))
    local bot=$((out_h))

    # Base gradient
    magick -size "${out_w}x${out_h}" gradient:"srgb(10,3,25)-srgb(35,12,65)" -alpha off \
        -fill "none" -stroke "${grid_color}" -strokewidth 1 \
        \
        -draw "line 0,${horizon_y} ${out_w},${horizon_y}" \
        \
        -draw "line ${vp_x},${horizon_y} 0,${bot}" \
        -draw "line ${vp_x},${horizon_y} $((out_w/8)),${bot}" \
        -draw "line ${vp_x},${horizon_y} $((out_w*2/8)),${bot}" \
        -draw "line ${vp_x},${horizon_y} $((out_w*3/8)),${bot}" \
        -draw "line ${vp_x},${horizon_y} $((out_w*5/8)),${bot}" \
        -draw "line ${vp_x},${horizon_y} $((out_w*6/8)),${bot}" \
        -draw "line ${vp_x},${horizon_y} $((out_w*7/8)),${bot}" \
        -draw "line ${vp_x},${horizon_y} ${out_w},${bot}" \
        \
        -draw "line 0,$((horizon_y + (bot - horizon_y) * 15 / 100)) ${out_w},$((horizon_y + (bot - horizon_y) * 15 / 100))" \
        -draw "line 0,$((horizon_y + (bot - horizon_y) * 35 / 100)) ${out_w},$((horizon_y + (bot - horizon_y) * 35 / 100))" \
        -draw "line 0,$((horizon_y + (bot - horizon_y) * 55 / 100)) ${out_w},$((horizon_y + (bot - horizon_y) * 55 / 100))" \
        -draw "line 0,$((horizon_y + (bot - horizon_y) * 75 / 100)) ${out_w},$((horizon_y + (bot - horizon_y) * 75 / 100))" \
        -draw "line 0,$((horizon_y + (bot - horizon_y) * 90 / 100)) ${out_w},$((horizon_y + (bot - horizon_y) * 90 / 100))" \
        \
        "$bg_path"

    # Horizon glow
    magick "$bg_path" \
        \( -size "${out_w}x6" "xc:${glow_pink}" -blur 0x8 \) \
        -gravity north -geometry "+0+$((horizon_y - 3))" -composite \
        \( -size "${out_w}x4" "xc:${glow_cyan}" -blur 0x6 \) \
        -gravity north -geometry "+0+$((horizon_y + 4))" -composite \
        "$bg_path"
}
