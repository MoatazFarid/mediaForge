# MediaForge v1.0.0

A powerful media processing application that helps you manipulate and transform video files. Currently supports video cutting functionality with more features coming soon.

## Installation

1. Install the required dependencies:
```bash
pip install -r requirements.txt
```

## Usage

You can use the script from the command line like this:

```bash
python video_cutter.py input_video.mp4 00:00:10 00:02:00 -o output/final_video.mp4
```

Arguments:
- First argument: Path to input video file
- Second argument: Start time (format: HH:MM:SS)
- Third argument: End time (format: HH:MM:SS)
- `-o` or `--output`: Output path (optional, defaults to 'output/cut_video.mp4')

## Example

```bash
python video_cutter.py my_video.mp4 00:01:30 00:02:45 -o output/trimmed_video.mp4
```

This will cut the video from 1 minute 30 seconds to 2 minutes 45 seconds and save it in the output folder.
