#!/usr/bin/env bash
# Template: absolutely
# Claude's color palette. The warm sand, terracotta, and that unmistakable orange.

TEMPLATE_NAME="absolutely"
TEMPLATE_DESC="Warm sand, terracotta, and a thoughtful palette"
BG_TYPE="solid"
BG_COLOR="srgb(250,244,237)"
PADDING=60
CORNER_RADIUS=14
SHADOW_BLUR=24
SHADOW_OFFSET=6
SHADOW_COLOR="rgba(120,60,20,0.18)"

custom_background() {
    local bg_path="$1"
    local out_w="$2"
    local out_h="$3"

    # Claude palette
    local sand="srgb(250,244,237)"       # warm cream bg
    local terracotta="srgb(217,119,87)"   # the terracotta
    local orange_warm="srgb(232,135,67)"  # warm orange
    local brown_soft="srgb(180,140,110)"  # muted brown
    local peach="srgb(240,190,160)"       # soft peach

    # Warm sand background with subtle Claude accents
    # Bottom-right corner: soft terracotta blob
    # Top-left: thin peach accent line
    magick -size "${out_w}x${out_h}" "xc:${sand}" -alpha off \
        \( -size "$((out_w/3))x$((out_h/3))" radial-gradient:"${peach}-${sand}" \) \
        -gravity southeast -composite \
        \( -size "$((out_w/4))x$((out_h/4))" radial-gradient:"${terracotta}30-${sand}" \) \
        -gravity southeast -geometry "+$((out_w/8))+$((out_h/8))" -composite \
        -fill "${terracotta}" \
        -draw "rectangle 0,$((out_h-4)) $((out_w/3)),$((out_h))" \
        -fill "${orange_warm}" \
        -draw "rectangle $((out_w/3)),$((out_h-4)) $((out_w*2/3)),$((out_h))" \
        -fill "${brown_soft}" \
        -draw "rectangle $((out_w*2/3)),$((out_h-4)) $((out_w)),$((out_h))" \
        "$bg_path"
}
