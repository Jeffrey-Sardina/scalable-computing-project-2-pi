#!/bin/bash

echo 'setting up environment'
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa
source ~/captcha_env/bin/activate
cd ~/solver/scalable-computing-project-2-pi/

echo 'attempting to check for and apply updates (timeout 60 seconds)'
git reset --hard
timeout 60 git pull
chmod u+x startup.sh
exitstatus=$?
case $exitstatus in
    124)
        echo $exitstatus 'failed to get updates, continuing with pre-existing code'
        ;;
    125)
        echo $exitstatus 'timeout command failed'
        ;;
    126)
        echo $exitstatus 'git command cannot be invoked'
        ;;
    127)
        echo $exitstatus 'git command not found'
        ;;
    137)
        echo $exitstatus 'git command sent kill signal'
        ;;
    0)
        echo $exitstatus 'updates pulled successfully'
        ;;
    *)
        echo $exitstatus 'unknown error'
        ;;
esac

echo 'attempting to update / install needed packages (timeout 300 seconds)'
timeout 300 python3 install.py

echo 'Running classification'
python3 classify.py --model-name model/model_2 --captcha-dir ~/solver/in/ --output ~solver/out/model_2_output.txt --symbols model/symbols.txt --captcha-len 5 --processes 4
exitstatus=$?
if [$exitstatus == 0]
then
    echo $exitstatus 'classification ended successfully'
else
    echo $exitstatus 'classification failed'
fi
