#!/usr/bin/env python

import subprocess

# Clear the terminal
subprocess.call("reset")

process = subprocess.Popen("rostopic echo -b arc_1_back_left_2016-06-21-20-16-20.bag -p /slam_out_pose > slam_out_pose.txt", shell=True)
