#!/usr/bin/python3

import os
import sys
import subprocess

input_file = sys.argv[1]
output_folder = sys.argv[2]
output_ext = 'ogg'
silence_len = 3
min_chapter_len = 300
move_split_into_silence = True

total_length = float(subprocess.check_output(['ffprobe', '-v', 'error', '-show_entries', 'format=duration', '-of', 'default=noprint_wrappers=1:nokey=1', input_file]))

print("Total length: %f" % total_length)

chapter_count = 1

def save_chapter(start, end=None):
	global chapter_count
	if move_split_into_silence:
		if end:
			end += 1
		if start != 0:
			start += 1
	cmd = ['ffmpeg', '-i', input_file, '-c', 'copy', '-y', '-ss', str(start)]
	if end:
		cmd.extend(['-to', str(end)])
	cmd.extend([os.path.join(output_folder, '%03d.%s' % (chapter_count, output_ext))])
	print('=> Track: %03d.%s' % (chapter_count, output_ext))
	subprocess.check_output(cmd, stderr=subprocess.DEVNULL)
	chapter_count += 1

p = subprocess.Popen(['ffmpeg', '-i', input_file, '-af', 'silencedetect=n=-50dB:d=%i' % silence_len, '-y', '-f', 'opus', '/dev/null'], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
last_silence_start = 0
for line in iter(p.stderr.readline, b''):
	if b'silence_start:' in line:
		silence_start = float(line.split(b'silence_start: ')[1])
		print("   Progress: %f" % ((100*silence_start)/total_length))
		#print("   Silence: %f" % silence_start)
		if (last_silence_start + 300) <= silence_start:
			# Create a track
			save_chapter(last_silence_start, silence_start)
			last_silence_start = silence_start
save_chapter(last_silence_start)
