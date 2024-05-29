# Parse arguments for --o and --cd flags
open_nvim=false
change_dir=false

while [[ "$1" != "" ]]; do
	case $1 in
	--o)
		open_nvim=true
		;;
	--cd)
		change_dir=true
		;;
	*) ;;
	esac
	shift
done

# Run fzf with bat for preview and custom key bindings
selected_file=$(fzf --preview='
    if file --mime-type {} | grep -q "text"; then
        bat --style=numbers --color=always --wrap=auto {}
    elif file --mime-type {} | grep -q "image"; then
        echo -e "\e[3J\033[H\033[2J"  # Clear the screen to render the media box
        feh --scale-down --auto-zoom --image-bg black {}
    elif file --mime-type {} | grep -q "video"; then
        echo -e "\e[3J\033[H\033[2J"  # Clear the screen to render the media box
        mpv --no-audio --force-window --geometry=50%:50% --autofit=50% {}
    fi' \
	--bind shift-up:preview-page-up,shift-down:preview-page-down \
	--preview-window=right:50%)

if [[ -z "$selected_file" ]]; then
	echo "No file selected"
	exit 1
fi

echo "Selected file: $selected_file"

if $change_dir; then
	selected_dir=$(dirname "$selected_file")
	echo "Selected directory: $selected_dir"
	if ! cd "$selected_dir"; then
		echo "Failed to change directory to $selected_dir"
		exit 1
	fi
	echo "Changed directory to $selected_dir"
fi

if $open_nvim; then
	nvim "$selected_file"
fi
