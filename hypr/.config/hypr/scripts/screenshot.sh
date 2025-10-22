#!/bin/bash

hyprpicker -r -z &
sleep 0.1
hyprshot -m region -o ~/pictures/screenshots -f "A_($(date +'%d-%b'))_($(date +'%H-%M-%S')).png"
