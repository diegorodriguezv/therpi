#!/bin/bash
upperLimit=$((60))
lowerLimit=$((50))
gpioPin=4
function initGpio(){
  echo "Initializing GPIO pin $gpioPin"
  trap "echo cleaning up... nothing to do; echo bye" EXIT
  sleep 1
  echo "Initialized GPIO pin $gpioPin"
}
function startCooling(){
 pinctrl set $gpioPin op dh
}
function stopCooling(){
 pinctrl set $gpioPin op dl
}
initGpio
echo "Upper limit: $upperLimit"
echo "Lower limit:  $lowerLimit"
echo "Starting therpi"
while true
do
 cpuTemp0=$(cat /sys/class/thermal/thermal_zone0/temp)
 cpuTempM=$((cpuTemp0/1000))
 cpuTemp=$((cpuTempM))
 echo "Current temp.: $cpuTemp"
 if [ $cpuTemp -gt $upperLimit ];then
  echo "Too hot"
  echo "Start cooling"
  startCooling
 elif [ $cpuTemp -lt $lowerLimit ];then
  echo "Cold enough"
  echo "Stop cooling"
  stopCooling
 else
  echo "Temp ok"
  echo "Nothing to do"
 fi
 sleep .5
done
