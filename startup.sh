#!/bin/bash

echo 'setting up environment'
eval `ssh-agent -s`
ssh-add ~/.ssh/id_rsa
source ~/captcha_env/bin/activate
cd ~/solver/scalable-computing-project-2-pi/

echo 'attempting to check for and apply updates (timeout 60 seconds)'
timeout 60 git pull
exitstatus=$?
if [$exitstatus == 124]
then
    echo 'failed to get updates, continuing with pre-existing code'
else
    echo 'updates pulled successfully'

echo 'attempting to update / install needed packages (timeout 300 seconds)'
timeout 300 pip3 install -r requirements.txt
exitstatus=$?
if [$exitstatus == 124]
then
    echo 'failed to install / update packages, this may cause classification to fail'
else
    echo 'packages installed and updated successfully'

echo 'Running classification'
python3 classify.py ...
exitstatus=$?
if [$exitstatus == 0]
then
    echo 'classification ended successfully'
else
    echo 'classification failed'
