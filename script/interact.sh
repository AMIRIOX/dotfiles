#!/usr/bin/env bash

WALLPAPER_DIR="${HOME}/Pictures/wallpaper"
_WALLPAPER_STATUS_FILE="${HOME}/.cache/current_wallpaper_path.txt"
_SWAYBG_BASE_COMMAND="nohup swaybg -o '*' -m fill"

_get_wallpaper_list() {
    if [ ! -d "$WALLPAPER_DIR" ]; then
        rofi -e "Directory not found: $WALLPAPER_DIR"
        return 1 
    fi
    find "$WALLPAPER_DIR" -type f \( \
        -iname "*.jpg" -o -iname "*.jpeg" -o \
        -iname "*.png" -o -iname "*.gif" -o \
        -iname "*.bmp" -o -iname "*.webp" \
    \) | sort
    return 0 
}


_set_wallpaper() {
        local image_path="$1"

    if [ -z "$image_path" ]; then
        rofi -e "No path"
        return 1
    fi
    if [ ! -f "$image_path" ]; then
        rofi -e "No such file: ${image_path##*/}"
        return 1
    fi

    if [ -z "$SWAYSOCK" ] && [ -n "$XDG_RUNTIME_DIR" ]; then
        local potential_swaysock
        potential_swaysock=$(find "$XDG_RUNTIME_DIR" -maxdepth 1 -type s -name "sway-ipc.*.sock" -print -quit 2>/dev/null)
        if [ -z "$potential_swaysock" ]; then
             potential_swaysock=$(find "$XDG_RUNTIME_DIR/hypr" -maxdepth 1 -type s -name ".socket.sock" -print -quit 2>/dev/null)
        fi
        if [ -S "$potential_swaysock" ]; then
            export SWAYSOCK="$potential_swaysock"
        fi
    fi

    if pgrep -x swaybg > /dev/null; then
        killall swaybg
        sleep 0.5
    fi
    
    ( swaybg -m fill -i "$image_path" >/dev/null 2>&1 ) &
    
    echo "$image_path" > "$_WALLPAPER_STATUS_FILE"
    return 0

}


_handle_wallpaper_select() {
    local all_wallpapers_array=()
    
    mapfile -t all_wallpapers_array < <(_get_wallpaper_list)
    if [ $? -ne 0 ] || [ ${#all_wallpapers_array[@]} -eq 0 ]; then 
        
        return 1
    fi
    local count=${#all_wallpapers_array[@]}

    local rofi_options_str=""
    for ((i=0; i<$count; i++)); do
        
        rofi_options_str+="$(echo "${all_wallpapers_array[$i]}" | sed "s|^${WALLPAPER_DIR}/||")\n"
    done

    local selected_index_str
    selected_index_str=$(echo -e "${rofi_options_str%\\n}" | \
        rofi -dmenu -p "Wallpaper Select" -i -mesg "found $count wallpapers" -format 'i') 
    
    if [ -n "$selected_index_str" ]; then
        if [[ "$selected_index_str" =~ ^[0-9]+$ ]] && [ "$selected_index_str" -lt "$count" ] && [ "$selected_index_str" -ge 0 ]; then
            _set_wallpaper "${all_wallpapers_array[$selected_index_str]}"
        else
            rofi -e "Invalid index"
            return 1
        fi
    fi
}


_handle_wallpaper_random() {
    local all_wallpapers_array=()
    mapfile -t all_wallpapers_array < <(_get_wallpaper_list)
    if [ $? -ne 0 ] || [ ${#all_wallpapers_array[@]} -eq 0 ]; then return 1; fi
    local count=${#all_wallpapers_array[@]}
    
    local random_index=$(( RANDOM % count ))
    _set_wallpaper "${all_wallpapers_array[$random_index]}"
}


_handle_wallpaper_next_prev() {
    local direction="$1" 
    local all_wallpapers_array=()
    mapfile -t all_wallpapers_array < <(_get_wallpaper_list)
    if [ $? -ne 0 ] || [ ${#all_wallpapers_array[@]} -eq 0 ]; then return 1; fi
    local count=${#all_wallpapers_array[@]}

    local current_wallpaper_path=""
    if [ -f "$_WALLPAPER_STATUS_FILE" ]; then
        current_wallpaper_path=$(cat "$_WALLPAPER_STATUS_FILE")
    fi
    local current_index=-1 
    if [ -n "$current_wallpaper_path" ]; then
        for i in "${!all_wallpapers_array[@]}"; do
            if [[ "${all_wallpapers_array[$i]}" == "$current_wallpaper_path" ]]; then
                current_index=$i; break;
            fi
        done
    fi

    local new_index=0
    if [ $current_index -eq -1 ]; then
        if [ "$direction" == "next" ]; then new_index=0;
        else new_index=$((count - 1)); fi
    else
        if [ "$direction" == "next" ]; then new_index=$(( (current_index + 1) % count ));
        else new_index=$(( (current_index - 1 + count) % count )); fi
    fi
    
    _set_wallpaper "${all_wallpapers_array[$new_index]}"
}

declare -A options
options=(
    ["Wallpaper: Next"]="_handle_wallpaper_next_prev \"next\""
    ["Wallpaper: Prev"]="_handle_wallpaper_next_prev \"prev\""
    ["Wallpaper: Select"]="_handle_wallpaper_select"
    ["Wallpaper: Random"]="_handle_wallpaper_random"
)

if [ -z "$@" ]; then
    for key in "${!options[@]}"; do
        echo "$key"
    done
else
    SELECTED_DESCRIPTION="$@"
    COMMAND_TO_EXECUTE="${options[$SELECTED_DESCRIPTION]}"

    if [ -n "$COMMAND_TO_EXECUTE" ]; then
        (eval "$COMMAND_TO_EXECUTE") > /dev/null 2>&1 &
    else
        rofi -e "Unknown option selected: $SELECTED_DESCRIPTION"
        exit 1
    fi
fi

exit 0
