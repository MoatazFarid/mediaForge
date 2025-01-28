import os
from moviepy.editor import VideoFileClip

def cut_video(input_path, output_path, start_time, end_time):
    """
    Cut a video from start_time to end_time and save it to output_path.
    
    Args:
        input_path (str): Path to input video file
        output_path (str): Path to save the output video
        start_time (str): Start time in format "HH:MM:SS"
        end_time (str): End time in format "HH:MM:SS"
    """
    try:
        # Convert time strings to seconds
        def time_to_seconds(time_str):
            h, m, s = map(int, time_str.split(':'))
            return h * 3600 + m * 60 + s

        start_seconds = time_to_seconds(start_time)
        end_seconds = time_to_seconds(end_time)

        # Create output directory if it doesn't exist
        os.makedirs(os.path.dirname(output_path), exist_ok=True)

        # Load the video
        video = VideoFileClip(input_path)

        # Cut the video
        cut_video = video.subclip(start_seconds, end_seconds)

        # Write the result to a file
        cut_video.write_videofile(output_path)

        # Close the video to free up resources
        video.close()
        cut_video.close()

        return True, "Video cut successfully!"

    except Exception as e:
        return False, f"Error: {str(e)}"

if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser(description='Cut a video between two time points')
    parser.add_argument('input_video', help='Path to input video file')
    parser.add_argument('start_time', help='Start time in format HH:MM:SS')
    parser.add_argument('end_time', help='End time in format HH:MM:SS')
    parser.add_argument('--output', '-o', default='output/cut_video.mp4',
                        help='Output path (default: output/cut_video.mp4)')

    args = parser.parse_args()
    
    success, message = cut_video(args.input_video, args.output, args.start_time, args.end_time)
    print(message)
