#!/bin/bash

while true; do

    PLAYER_LIST=$(playerctl -l 2>/dev/null)

    ACTIVE_PLAYER=""
    PAUSED_PLAYER=""

    for PLAYER in $PLAYER_LIST; do
        PLAYER_STATUS=$(playerctl --player="$PLAYER" status 2>/dev/null)
        if [ "$PLAYER_STATUS" = "Playing" ]; then
            ACTIVE_PLAYER="$PLAYER"
            break
        elif [ "$PLAYER_STATUS" = "Paused" ]; then
            PAUSED_PLAYER="$PLAYER"
        fi
    done

    DISPLAY_PLAYER=""
    if [ -n "$ACTIVE_PLAYER" ]; then
        DISPLAY_PLAYER="$ACTIVE_PLAYER"
    elif [ -n "$PAUSED_PLAYER" ]; then
        DISPLAY_PLAYER="$PAUSED_PLAYER"
    fi

    if [ -n "$DISPLAY_PLAYER" ]; then
        PLAYER_STATUS=$(playerctl --player="$DISPLAY_PLAYER" status 2>/dev/null)
        TITLE=$(playerctl --player="$DISPLAY_PLAYER" metadata title 2>/dev/null)
        ARTIST=$(playerctl --player="$DISPLAY_PLAYER" metadata artist 2>/dev/null)
        ALBUM=$(playerctl --player="$DISPLAY_PLAYER" metadata album 2>/dev/null)

        PLAY_ICON=""
        PAUSE_ICON=""
        SPOTIFY_ICON=""
        DEFAULT_ICON=""

        OUTPUT_TEXT=""
        PLAYER_ICON="$DEFAULT_ICON"

        if [[ "$DISPLAY_PLAYER" == *"spotify"* ]]; then
            PLAYER_ICON="$SPOTIFY_ICON"
        elif [[ "$DISPLAY_PLAYER" == *"yesplaymusic"* ]]; then
            PLAYER_ICON=""
        fi

        STATUS_ICON=""
        if [ "$PLAYER_STATUS" = "Playing" ]; then
            STATUS_ICON="$PLAY_ICON"
        elif [ "$PLAYER_STATUS" = "Paused" ]; then
            STATUS_ICON="$PAUSE_ICON"
        fi

        if [ -n "$TITLE" ]; then
            if [ -n "$ALBUM" ]; then
                OUTPUT_TEXT="$STATUS_ICON $TITLE - $ARTIST"
            else
                OUTPUT_TEXT="$STATUS_ICON $TITLE"
            fi
        else
            OUTPUT_TEXT="$STATUS_ICON"
        fi

        echo "{\"text\": \"$OUTPUT_TEXT\", \"tooltip\": \"$TITLE by $ARTIST\", \"alt\": \"$PLAYER_STATUS\"}"

    else
        echo "{}"
    fi

    sleep 1

done
