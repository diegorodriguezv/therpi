#!/bin/bash
upperLimit=$((60))
lowerLimit=$((50))
gpioPin=4
function initGpio(){
 echo "Initializing GPIO pin $gpioPin"
 if [ ! -d  /sys/class/gpio/gpio$gpioPin ];then
  trap "echo $gpioPin > /sys/class/gpio/unexport ; echo bye" EXIT
  echo $gpioPin > /sys/class/gpio/export
  sleep 1
 fi
 echo out > /sys/class/gpio/gpio$gpioPin/direction
 echo "Initialized GPIO pin $gpioPin"
}
function startCooling(){
 echo 1 > /sys/class/gpio/gpio$gpioPin/value
}
function stopCooling(){
 echo 0 > /sys/class/gpio/gpio$gpioPin/value
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
