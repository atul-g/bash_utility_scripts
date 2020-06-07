# Video Playlist Time Calculator

This script sums up and returns the total time of all the videos inside a given directory. This script also includes the videos found inside a sub-directory within the argument directory.

### Dependencies
This script makes use of the `ffmpeg` command. Make sure `ffmpeg` is installed before running this script: `sudo apt-get install ffmpeg`.

### Usage
1. Run this script by entering the name of the script along with the path of the target directory as argument:  
`./playlist_calc "/path/to/directory"`

2. Try to use quotes while specifying the path, sometimes the given path can have spaces or other characters in it. Using quotes can help avoid any unecessary errors.
