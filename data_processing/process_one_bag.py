#!/usr/bin/env python

import numpy
import rosbag
import subprocess

from tf import transformations as tft

def process_bag( bagName, bagNumber ):

  # Clear the terminal
  subprocess.call("reset")

  bag = rosbag.Bag( bagName )

  # Store for plotting
  x_slam = []
  y_slam = []
  theta_slam = []
  time = []
  front_l_wheel_vel = []
  front_r_wheel_vel = []

  ################################
  # x_slam, y_slam, theta_slam
  ################################

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

      # Store x, y, theta for analysis
      x_slam.append(msg.pose.position.x)
      y_slam.append(msg.pose.position.y)
      theta_slam.append( tft.euler_from_quaternion([msg.pose.orientation.x,msg.pose.orientation.y,msg.pose.orientation.z,msg.pose.orientation.w])[2] )

  numpy.savetxt("x_y_theta_slam/" + str(bagNumber) + ".txt", numpy.transpose([time, x_slam, y_slam, theta_slam]))

  ################################
  # Wheel speeds
  ################################

  # Get the initial time so we can subtract it and start from zero
  for topic, msg, t in bag.read_messages(topics=['/nrg_nav_filter/joints']):
      start_time = t.to_sec()
      break

  time = []

  for topic, msg, t in bag.read_messages(topics=['/nrg_nav_filter/joints']):
      #print msg.velocity[0]

      # Store time
      # Subtract the initial time so we start from zero
      time.append(t.to_sec()-start_time)

      # Store wheel velocities for analysis
      # Wheel positions are given by /nrg_nav_filter/joints.position
      # [front_left, front_right, rear_left, rear_right]
      # We'll just save the first 2 cause each side is identical
      front_l_wheel_vel.append(msg.velocity[0])
      front_r_wheel_vel.append(msg.velocity[1])

  numpy.savetxt("wheel_vel/" + str(bagNumber) + ".txt", numpy.transpose([time, front_l_wheel_vel, front_r_wheel_vel]))

  ################################
  # COM
  ################################

  for topic, msg, t in bag.read_messages(topics=['/VB_com']):
      # Store the COM position
      # This is in /map (but everything else is in /base_link)
      # However, it doesn't matter b/c the frames are coincident initially
      com_x = msg.point.x
      com_y = msg.point.y
      com_z = msg.point.z

  numpy.savetxt("COM/" + str(bagNumber) + ".txt", [com_x, com_y, com_z])


  bag.close()
