#!/bin/bash

sleep 1
ros2 launch zed_wrapper zed2i.launch.py &

# Wait for commands to finish
wait

