#!/usr/bin/env python

import matplotlib.pyplot as plt
import numpy
import rosbag
import subprocess

# Clear the terminal
subprocess.call("reset")

bag = rosbag.Bag('arc_1_back_left_2016-06-21-20-16-20.bag')

# Store for plotting
x_slam = []
y_slam = []
time = []
front_l_wheel_vel = []
front_r_wheel_vel = []

# Get the initial time so we can subtract it and start from zero
for topic, msg, t in bag.read_messages(topics=['/slam_out_pose']):
    start_time = t.to_sec()
    break

for topic, msg, t in bag.read_messages(topics=['/slam_out_pose']):
    #print msg
    #print msg.pose.position.x

    # Store time
    # Subtract the initial time so we start from zero
    time.append(t.to_sec()-start_time)

    # Store x, y for analysis
    x_slam.append(msg.pose.position.x)
    y_slam.append(msg.pose.position.y)

numpy.savetxt('time/1.txt', numpy.transpose([time]))
numpy.savetxt('x_y_slam/1.txt', numpy.transpose([x_slam, y_slam]))

# Plot x vs time
# plt.plot(time,x_slam)
# plt.ylabel('X [m]')
# plt.xlabel('Time [s]')
# plt.show()


for topic, msg, t in bag.read_messages(topics=['/nrg_nav_filter/joints']):
    #print msg.velocity[0]

    # Store wheel velocities for analysis
    # Wheel positions are given by /nrg_nav_filter/joints.position
    # [front_left, front_right, rear_left, rear_right]
    # We'll just save the first 2 cause each side is identical
    front_l_wheel_vel.append(msg.velocity[0])
    front_r_wheel_vel.append(msg.velocity[1])

numpy.savetxt('wheel_vel/1.txt', numpy.transpose([front_l_wheel_vel, front_r_wheel_vel]))

bag.close()
