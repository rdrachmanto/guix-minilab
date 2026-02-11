# First update the user guix to get new commits
guix pull -C /home/main/Guix/channels-unpinned.scm

# Then update the pinned guix channels file
echo ";; FILE GENERATED FROM upgrade-guix.sh" > channels.scm
echo ";; DO NOT EDIT" >> channels.scm
guix describe --format=channels >> channels.scm

# Finally update the system-level guix with the new pinned channels
sudo -i guix pull -C /home/main/Guix/channels.scm

# Final sanity check
echo ""
echo "==============================="
echo "user level `guix describe` "
echo ""
guix describe

echo ""
echo "==============================="
echo "system level `guix describe` "
echo ""
sudo -i guix describe
