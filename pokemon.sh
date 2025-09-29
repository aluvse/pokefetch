#!/bin/bash

# Pokefetch - Random Pokémon System Info
# Customized by [Your Name]
# Based on original by discomanfulanito
# for everyone — as code should be

# Use pokeget's random feature to get ANY available pokemon
RANDOM_POKEMON="random"

# Change with your fetcher
FETCHER="fastfetch --config examples/21.jsonc"

# Calculate fetcher height for centering
FETCHER_HEIGHT=$((($($FETCHER | wc -l) + 1) / 2))

# Extra settings
EXTRA_PADDING_H=2
EXTRA_PADDING_W=0

# Room for the sprite
WIDTH=15

# Gets a random sprite via pokeget from ALL available pokemon
sprite=$(pokeget $RANDOM_POKEMON --hide-name)

# If the above fails, try getting random by region as fallback
if [ $? -ne 0 ] || [ -z "$sprite" ]; then
    # Try getting random from different regions as fallback
    REGIONS=("kanto" "johto" "hoenn" "sinnoh" "unova" "kalos" "alola" "galar")
    random_region=${REGIONS[RANDOM % ${#REGIONS[@]}]}
    sprite=$(pokeget $random_region --hide-name)
fi

# Check if sprite was obtained successfully
if [ -z "$sprite" ]; then
    echo "Error: Could not fetch Pokémon sprite"
    exit 1
fi

# Gets sprite's height
height=$(echo "$sprite" | wc -l)

# Pad for vertical centering
pad_top=$((($FETCHER_HEIGHT - $height) / 2))
pad_top=$((pad_top + EXTRA_PADDING_H))

# Just for safety
if [ $pad_top -lt 0 ]; then
    pad_top=0
fi

# Gets sprite's sprite_width
sprite_width=0

# Iterate sprite's lines
while IFS= read -r line; do
    # Gets line's width
    line_w=${#line}
    # Compare and Update sprite_width
    if ((line_w > sprite_width)); then
        sprite_width=$line_w
    fi
done <<<"$sprite"

# Real sprite_width (idk why the other is scaled)
sprite_width=$(((sprite_width + 35 - 1) / 35))

# Calculate the lateral padding
pad_lat=$((($WIDTH - sprite_width) / 2))
pad_lat=$((pad_lat + EXTRA_PADDING_W))

# Just for safety
if [ $pad_lat -lt 0 ]; then
    pad_lat=0
fi

# Display with fastfetch
echo "$sprite" | $FETCHER --file-raw - --logo-padding-top $pad_top --logo-padding-left $pad_lat --logo-padding-right $pad_lat
