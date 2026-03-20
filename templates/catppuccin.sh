#!/usr/bin/env bash
# Template: catppuccin
# Catppuccin Mocha palette. Warm dark base with diagonal accent stripes (varied thickness).

TEMPLATE_NAME="catppuccin"
TEMPLATE_DESC="Catppuccin Mocha palette, diagonal pastel stripes"
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

    # Diagonal stripes — 30° angle, right side, varied thickness
    # Lines go from mid-top-right area sweeping down-right
    # We draw thick angled parallelograms using polygon

    # Stripe configs: color, thickness
    # Rosewater (thick), Flamingo (thin), Pink (medium), Mauve (thick), Red (thin), Peach (medium)

    local gap=10

    # Calculate line positions — they sit in the right portion of the canvas
    # At 30° angle: for every 1px down, go ~1.7px right (tan30 ≈ 0.577, so dx/dy ≈ 1.73)
    # We'll define each stripe by its top-left Y start, and compute endpoints

    magick -size "${out_w}x${out_h}" "xc:srgb(30,30,46)" -alpha off \
        -fill "srgb(245,224,220)" \
        -draw "polygon $((out_w*45/100)),0 $((out_w*45/100+14)),0 $((out_w)),$(((out_w*55/100-14)*100/173)) $((out_w)),$(((out_w*55/100)*100/173))" \
        \
        -fill "srgb(242,205,205)" \
        -draw "polygon $((out_w*50/100)),0 $((out_w*50/100+6)),0 $((out_w)),$(((out_w*50/100-6)*100/173)) $((out_w)),$(((out_w*50/100)*100/173))" \
        \
        -fill "srgb(245,194,231)" \
        -draw "polygon $((out_w*54/100)),0 $((out_w*54/100+10)),0 $((out_w)),$(((out_w*46/100-10)*100/173)) $((out_w)),$(((out_w*46/100)*100/173))" \
        \
        -fill "srgb(203,166,247)" \
        -draw "polygon $((out_w*59/100)),0 $((out_w*59/100+16)),0 $((out_w)),$(((out_w*41/100-16)*100/173)) $((out_w)),$(((out_w*41/100)*100/173))" \
        \
        -fill "srgb(243,139,168)" \
        -draw "polygon $((out_w*65/100)),0 $((out_w*65/100+5)),0 $((out_w)),$(((out_w*35/100-5)*100/173)) $((out_w)),$(((out_w*35/100)*100/173))" \
        \
        -fill "srgb(250,179,135)" \
        -draw "polygon $((out_w*68/100)),0 $((out_w*68/100+10)),0 $((out_w)),$(((out_w*32/100-10)*100/173)) $((out_w)),$(((out_w*32/100)*100/173))" \
        \
        "$bg_path"
}
