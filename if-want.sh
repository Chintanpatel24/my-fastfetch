#This script is for those who want to use the non-repeating images in one cycle. 

LOGO_DIR="/home/cachy/.config/fastfetch/PNGs"
HISTORY_FILE="/home/cachy/.config/fastfetch/logo_history"

# Get all PNGs
mapfile -t FILES < <(find "$LOGO_DIR" -name "*.png" -type f)

# Initialize history if missing
touch "$HISTORY_FILE"

# Remove files from history that no longer exist
awk -v dir="$LOGO_DIR" 'BEGIN{while((getline f < dir "/tmp.list") > 0) files[f]=1; for(f in files) if(!system("[ -f \"" f "\" ]")) next; else print f}' > "$HISTORY_FILE".tmp && mv "$HISTORY_FILE".tmp "$HISTORY_FILE"

# If all files have been used, clear history
if [ $(wc -l < "$HISTORY_FILE") -eq ${#FILES[@]} ]; then
    > "$HISTORY_FILE"
fi

# Select a random file not in history
while true; do
    RAND_FILE="${FILES[RANDOM % ${#FILES[@]}]}"
    grep -qF "$RAND_FILE" "$HISTORY_FILE" || break
done

# Add to history and print
echo "$RAND_FILE" >> "$HISTORY_FILE"
echo "$RAND_FILE"   
