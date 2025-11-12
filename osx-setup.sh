#!/usr/bin/env bash

set -Eeuo pipefail

# macOS Setup Script - Compatible with macOS 15 Sequoia & 26 Tahoe
#
# Sources:
# - https://macos-defaults.com
# - https://github.com/mathiasbynens/dotfiles
# - https://github.com/driesvints/dotfiles
#

echo "Running macOS setup for Sequoia/Tahoe..."

# Detect macOS version
OS_VERSION=$(sw_vers -productVersion)
echo "Detected macOS version: $OS_VERSION"

echo "Some settings require Full Disk Access for Terminal.app"
echo ""

# ============================================================================
# === SCRIPT INITIALIZATION ===
# ============================================================================

# Close any open System Settings panes
osascript -e 'tell application "System Settings" to quit'

# Ask for the administrator password upfront
sudo -v

# ============================================================================
# === SYSTEM CORE SETTINGS ===
# ============================================================================

echo "Configuring system core settings..."

# Bug in Tahoe needs this
launchctl setenv CHROME_HEADLESS 1

# Disable startup noise
# sudo nvram StartupMute=%01

# Automatically switch between light and dark mode
# defaults write NSGlobalDomain AppleInterfaceStyleSwitchesAutomatically -bool true

# Reveal IP address, hostname, OS version when clicking login clock
sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName

# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# Save to disk (not iCloud) by default
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Expand print panel by default
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# Disable tiled window margins (Sequoia's window tiling)
# defaults write com.apple.WindowManager EnableTiledWindowMargins -bool false

# Reduce motion (more effective than NSAutomaticWindowAnimationsEnabled)
defaults write NSGlobalDomain ReduceMotionEnabled -bool true

# ============================================================================
# === FINDER & FILE MANAGEMENT ===
# ============================================================================

echo "Configuring Finder settings..."

# Use list view by default
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Keep folders on top when sorting by name
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# Disable Finder animations for speed
defaults write com.apple.finder DisableAllAnimations -bool true

# Show "Quit Finder" menu item
defaults write com.apple.finder QuitMenuItem -bool true

# Show hidden files (Cmd+Shift+. also works)
defaults write com.apple.finder AppleShowAllFiles -bool true

# Always show file extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Disable warning when changing file extensions
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Search current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Show path bar and status bar
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true

# Show POSIX path in title
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# New windows open to home folder
defaults write com.apple.finder NewWindowTarget -string "PfHm"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"

# Show drives on desktop
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

# Show ~/Library folder
chflags nohidden ~/Library

# Show /Volumes folder
sudo chflags nohidden /Volumes

# Disable .DS_Store on network and USB drives
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# ============================================================================
# === DOCK & MISSION CONTROL ===
# ============================================================================

echo "Configuring Dock and Mission Control..."

# Auto-hide Dock
defaults write com.apple.dock autohide -bool true

# Fast Dock animations
defaults write com.apple.dock autohide-time-modifier -float 0.15
defaults write com.apple.dock autohide-delay -float 0

# Smaller Dock icons
# defaults write com.apple.dock tilesize -int 48

# No magnification
defaults write com.apple.dock magnification -bool false

# Scale effect for minimizing
defaults write com.apple.dock mineffect -string "scale"

# Hide recent applications
defaults write com.apple.dock show-recents -bool false

# Show indicator lights for open applications
defaults write com.apple.dock show-process-indicators -bool true

# Make hidden app icons translucent
defaults write com.apple.dock showhidden -bool true

# Don't rearrange Spaces automatically
defaults write com.apple.dock mru-spaces -bool false

# Group windows by application in Mission Control
defaults write com.apple.dock expose-group-by-app -bool true

# Disable hot corners (set all to 0 for no action)
defaults write com.apple.dock wvous-tl-corner -int 0
defaults write com.apple.dock wvous-tr-corner -int 0
defaults write com.apple.dock wvous-bl-corner -int 0
defaults write com.apple.dock wvous-br-corner -int 0

# Enable scroll gesture to open Dock stacks
# defaults write com.apple.dock scroll-to-open -bool true

# ============================================================================
# === UI & ANIMATIONS ===
# ============================================================================

echo "Configuring UI and animations..."

# Reduce menu bar spacing for MacBooks with notch
# defaults write NSGlobalDomain NSStatusItemSelectionPadding -int 10
# defaults write NSGlobalDomain NSStatusItemSpacing -int 10

# Faster window resize
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001

# Instant Quick Look
defaults write NSGlobalDomain QLPanelAnimationDuration -float 0

# ============================================================================
# === INPUT & TEXT ===
# ============================================================================

echo "Configuring input and text settings..."

# Disable all automatic text corrections
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticTextCompletionEnabled -bool false
defaults write -g NSAutoFillHeuristicControllerEnabled -bool false

# Disable language indicator
defaults write kCFPreferencesAnyApplication TSMLanguageIndicatorEnabled -bool false

# Full keyboard access (Tab through all controls)
# Note: Sequoia changed values - use 2, not 3
# https://github.com/nix-darwin/nix-darwin/issues/1378
defaults write NSGlobalDomain AppleKeyboardUIMode -int 2

# Disable press-and-hold for accented characters
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Fast keyboard repeat rate (requires logout)
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15


# Trackpad: Enable tap-to-click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Enable three-finger drag
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool true

# ============================================================================
# === SCREENSHOTS ===
# ============================================================================

echo "Configuring screenshot settings..."

# Save as PNG
defaults write com.apple.screencapture type -string "png"

# Save to Downloads
# defaults write com.apple.screencapture location -string "${HOME}/Downloads"

# Disable shadow in screenshots
defaults write com.apple.screencapture disable-shadow -bool true

# No floating thumbnail
# defaults write com.apple.screencapture show-thumbnail -bool false

# Custom name prefix
# defaults write com.apple.screencapture name -string "Screenshot"

# ============================================================================
# === ACTIVITY MONITOR ===
# ============================================================================

echo "Configuring Activity Monitor..."

# Show all processes
defaults write com.apple.ActivityMonitor ShowCategory -int 0

# Sort by CPU usage
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0

# Show CPU history in Dock icon
defaults write com.apple.ActivityMonitor IconType -int 6

# Update frequency: Often (2 seconds)
defaults write com.apple.ActivityMonitor UpdatePeriod -int 2

# ============================================================================
# === PRIVACY & SECURITY ===
# ============================================================================

echo "Configuring privacy settings..."

# Disable Spotlight web search (keeps searches local)
defaults write com.apple.lookup.shared LookupSuggestionsDisabled -bool true

# Disable crash reporter dialog
defaults write com.apple.CrashReporter DialogType -string "none"

# ============================================================================
# === SYSTEM PREFERENCES ===
# ============================================================================

echo "Configuring system preferences..."

# Prevent Photos from auto-launching
# defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool YES

# Disable app state restoration
# defaults write NSGlobalDomain NSQuitAlwaysKeepsWindows -bool false
# defaults write com.apple.loginwindow TALLogoutSavesState -bool false
# defaults write com.apple.loginwindow LoginwindowLaunchesRelaunchApps -bool false

# Enable spring loading for directories
defaults write NSGlobalDomain com.apple.springing.enabled -bool true

# Remove spring loading delay
defaults write NSGlobalDomain com.apple.springing.delay -float 0

# ============================================================================
# === CLEANUP ===
# ============================================================================

echo "Cleaning up old settings..."

# Remove deprecated Launchpad settings if they exist
defaults delete com.apple.dock springboard-columns 2>/dev/null || true
defaults delete com.apple.dock springboard-rows 2>/dev/null || true

# Reset Launchpad
defaults write com.apple.dock ResetLaunchPad -bool true

# ============================================================================
# === APPLY CHANGES ===
# ============================================================================

echo "Applying changes..."

# Restart affected services
for app in "Finder" "Dock" "SystemUIServer" "WindowManager"; do
    killall "${app}" &> /dev/null || true
done

# Restart preference daemon
killall cfprefsd

echo ""
echo "✅ Setup complete!"
echo ""
echo "Consider rebooting for all changes to take effect."

# # 'yy' function (Terminal file explorer using yazi)
# function yy
#     set tmp (mktemp -t "yazi-cwd.XXXXXX")
#     yazi $argv --cwd-file="$tmp"
#     if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
#         builtin cd -- "$cwd"
#     end
#     rm -f -- "$tmp"
# end

# if status is-interactive
#     # Commands to run in interactive sessions can go here
# end
