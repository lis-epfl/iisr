clc
clear all
close all

T=readtable('name.csv');
R=T(:,3:5);
R=table2array(R);
%E=quat2eul(R)
%E=rad2deg(E);

figure()
plot(table2array(T(:,2)),R(:,1))
title("pitch angle")
xlabel("Time [seconds]")
ylabel("Pitch Angle [degrees]")
set(gca,'FontSize',12)

figure()
plot(table2array(T(:,2)),R(:,2))
title("yaw angle")
xlabel("time [s]")
ylabel("angle [degrees]")


figure()
plot(table2array(T(:,2)),R(:,3))
title("roll angle")
xlabel("time [s]")
ylabel("angle [degrees]")
