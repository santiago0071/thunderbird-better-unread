#!/usr/bin/env bash
# ==============================================================================
# Thunderbird Better Unread - One-Click Installer (macOS / Linux)
# ==============================================================================

set -e

echo "======================================================================"
echo "   Thunderbird Better Unread - One-Click Installer (macOS / Linux)    "
echo "======================================================================"
echo ""

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_CSS="${SCRIPT_DIR}/../chrome/userChrome.css"

if [ ! -f "$SOURCE_CSS" ]; then
    echo "[ERROR] userChrome.css not found at: $SOURCE_CSS"
    exit 1
fi

CANDIDATE_DIRS=()

# macOS Thunderbird Profiles
if [ -d "$HOME/Library/Thunderbird/Profiles" ]; then
    CANDIDATE_DIRS+=("$HOME/Library/Thunderbird/Profiles")
fi

# Linux Thunderbird Profiles
if [ -d "$HOME/.thunderbird" ]; then
    CANDIDATE_DIRS+=("$HOME/.thunderbird")
fi

# Flatpak / Snap locations
if [ -d "$HOME/.var/app/org.mozilla.Thunderbird/.thunderbird" ]; then
    CANDIDATE_DIRS+=("$HOME/.var/app/org.mozilla.Thunderbird/.thunderbird")
fi

if [ ${#CANDIDATE_DIRS[@]} -eq 0 ]; then
    echo "[ERROR] Thunderbird profiles directory not found!"
    echo "Checked standard macOS (~/Library/Thunderbird/Profiles) and Linux (~/.thunderbird) paths."
    echo "Please launch Thunderbird at least once to generate a profile."
    exit 1
fi

FOUND_COUNT=0

for BASE_DIR in "${CANDIDATE_DIRS[@]}"; do
    echo "[*] Searching under: $BASE_DIR"
    for PROFILE in "$BASE_DIR"/*; do
        if [ -d "$PROFILE" ]; then
            PROFILE_NAME=$(basename "$PROFILE")
            # Filter non-profile directories like 'Crash Reports'
            if [[ "$PROFILE_NAME" == "Crash Reports" || "$PROFILE_NAME" == "Pending Pings" ]]; then
                continue
            fi

            CHROME_DIR="$PROFILE/chrome"
            mkdir -p "$CHROME_DIR"
            cp -f "$SOURCE_CSS" "$CHROME_DIR/userChrome.css"
            echo "  --> [SUCCESS] Copied to $PROFILE_NAME/chrome/userChrome.css"

            USER_JS="$PROFILE/user.js"
            PREF_LINE='user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);'
            if [ -f "$USER_JS" ]; then
                if ! grep -q "toolkit.legacyUserProfileCustomizations.stylesheets" "$USER_JS"; then
                    echo "$PREF_LINE" >> "$USER_JS"
                    echo "  --> [CONFIG] Enabled stylesheet preference in user.js"
                fi
            else
                echo "$PREF_LINE" > "$USER_JS"
                echo "  --> [CONFIG] Created user.js and enabled stylesheet preference"
            fi

            FOUND_COUNT=$((FOUND_COUNT + 1))
        fi
    done
done

echo ""
echo "======================================================================"
if [ "$FOUND_COUNT" -gt 0 ]; then
    echo "[DONE] Successfully applied styles to $FOUND_COUNT profile(s)!"
    echo ""
    echo "Important:"
    echo "1. Restart Thunderbird if it is already open."
    echo "2. Enjoy clean, high-contrast unread cards!"
else
    echo "[WARNING] No valid profile subdirectories were updated."
fi
echo "======================================================================"
