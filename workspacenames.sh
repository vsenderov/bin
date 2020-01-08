#!/bin/zsh
# TODO parameterize ~/bin/workspacenames

#get desktop number
n=$(xdotool get_desktop)
n=$[n+1]

#get current workspace label
et=$(cat ~/bin/workspacenames | sed -n "$n p")

#prompt user for new workspace label
label=$(zenity --entry --entry-text="$et" --title="Workspace label" --text="New label")

if [ "$label" = "" ] ; then exit; fi

#replace the workspace label in our local file
sed "$n s/.*/$label/" -i ~/bin/workspacenames

#convert lines of the local file to an array gsettings can understand
magic=$(cat ~/bin/workspacenames | tr '\r\n' '|' | sed "s/.$/\"/;s/^/\"/;s/|/\",\"/g"|sed 's/\(.*\)/\[\1\]/')

#update settings
gsettings set org.gnome.desktop.wm.preferences workspace-names "$magic"
