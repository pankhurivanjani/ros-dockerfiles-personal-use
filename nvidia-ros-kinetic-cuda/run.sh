docker build .

XAUTH=/tmp/.docker.xauth

echo "Preparing Xauthority data..."
xauth_list=$(xauth nlist :0 | tail -n 1 | sed -e 's/^..../ffff/')
if [ ! -f $XAUTH ]; then
    if [ ! -z "$xauth_list" ]; then
        echo $xauth_list | xauth -f $XAUTH nmerge -
    else
        touch $XAUTH
    fi
    chmod a+r $XAUTH
fi

echo "Done."
echo ""
echo "Verifying file contents:"
file $XAUTH
echo "--> It should say \"X11 Xauthority data\"."
echo ""
echo "Permissions:"
ls -FAlh $XAUTH
echo ""
echo "Running docker..."

#docker run -it \
#    --e DISPLAY \
#    --env="QT_X11_NO_MITSHM=1" \
#    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
#    --env="XAUTHORITY=$XAUTH" \
#    --volume="$XAUTH:$XAUTH" \
#    --privileged \
#    --gpus all \
#    --net=host pankhurivanjani/nvidiaroskinetic:v0  bash
#echo "Done."
#    #--env="DISPLAY=$DISPLAY" \


docker run -it \
      --rm \
      --net=host \
      --privileged \
      --gpus all \
      -e DISPLAY \
      -e XAUTHORITY=/tmp/.Xauthority \
      -v ${XAUTHORITY}:/tmp/.Xauthority \
      -v /tmp/.X11-unix:/tmp/.X11-unix \
      pankhurivanjani/nvidiaroskinetic:v0  bash
