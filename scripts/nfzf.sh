#!/bin/bash

# Initialize flags
open_nvim=false
change_dir=false

# Parse arguments
echo "Parsing arguments..."
while [[ "$1" != "" ]]; do
	case $1 in
	--edit)
		echo "Flag --edit set"
		open_nvim=true
		;;
	--dir)
		echo "Flag --dir set"
		change_dir=true
		;;
	*)
		echo "Unknown argument: $1"
		;;
	esac
	shift
done

# Run fzf with bat for preview and custom key bindings
echo "Running fzf to select a file..."
selected_file=$(fzf --preview='
	if file --mime-type {} | rg -i "text"; then
		bat --style=numbers --color=always --wrap=auto {}
	elif file --mime-type {} | rg -i "image"; then
		echo -e "\e[3J\033[H\033[2J"  # Clear the screen to render the media box
		sleep 0.2
		feh --scale-down --auto-zoom --image-bg black {}
	elif file --mime-type {} | rg -i "video"; then
		echo -e "\e[3J\033[H\033[2J"  # Clear the screen to render the media box
		sleep 0.2
		mpv --no-audio --force-window --geometry=50%:50% --autofit=50% {}
	fi' \
	--bind shift-up:preview-page-up,shift-down:preview-page-down \
	--preview-window=right:50%)

# Check if a file was selected
if [[ -z "$selected_file" ]]; then
	echo "No file selected"
	exit 1
fi

echo "Selected file: $selected_file"

# Change directory if flag is set
if $change_dir; then
	dir_path=$(readlink -f "$selected_file" | xargs dirname)
	echo "Changing directory to: $dir_path"
	cd "$dir_path" || {
		echo "Failed to change directory to $dir_path"
		exit 1
	}
fi

# Open in nvim if flag is set
if $open_nvim; then
	echo "Opening file in nvim: $selected_file"
	nvim "$selected_file"
fi

# Log the current working directory for verification
echo "Current directory: $(pwd)"
