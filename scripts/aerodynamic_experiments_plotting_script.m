close all;
clear;
clc;
%% load aerodynamic data
configuration_id =["Hind_Wings","Hind_Wings_17cm_Elytra", ...
                   "Hind_Wings_14cm_Elytra", ...
                   "Hind_Wings_11cm_Elytra", ...
                   "17cm_Elytra","14cm_Elytra","11cm_Elytra"];

%corresponds to single wing area *2
configuration_wing_area = [0.0338,0.015238741+0.0338, ...
                           0.012549528+0.0338,0.009860443+0.0338, ...
                           0.015238741, 0.012549528, 0.009860443, ...
                           0.000462415]*2;
angle_of_attack_id = ["m3","0","p3","p6","p9","p12","p15","p18"];
%measured offset in degrees
angle_correction = -1;
angle_of_attack_value = [-3, 0, 3, 6, 9, 12, 15, 18] + angle_correction;

sensor_readings_mean_table = ...
    zeros(length(configuration_id),length(angle_of_attack_id),2);
drag_lift_table = ...
    zeros(length(configuration_id),length(angle_of_attack_id),9);

i=0; %index for a given configuration
j=0; %index for a given angle of attack
for name=configuration_id
    i=i+1;
    j=0;
    for angle = angle_of_attack_id
        j=j+1;
     if isfile(name+"/"+name+"_"+angle+".csv")
        [force_x,~,force_z]= readvars(name+"/"+name+"_"+angle+".csv");
     else
         error("not on the right directory")
     end
        
%taking 500 samples from stability region        
        x_mean= mean(force_x(end-1500:end-1000));
        z_mean= mean(force_z(end-1500:end-1000));
        x_std= std(force_x(end-1500:end-1000));
        z_std= std(force_z(end-1500:end-1000));

        sensor_readings_mean_table(i,j,1)=x_mean;
        sensor_readings_mean_table(i,j,2)=z_mean;

%projecting forces to extract lift and drag
        drag=(x_mean* cosd(angle_of_attack_value(j)) + ...
              sind(angle_of_attack_value(j)) * z_mean);
        lift= (- x_mean * sind(angle_of_attack_value(j)) + ...
              z_mean * cosd(angle_of_attack_value(j)));
        drag_std=(x_std* cosd(angle_of_attack_value(j)) + ...
                  sind(angle_of_attack_value(j)) * z_std);
        lift_std= (- x_std * sind(angle_of_attack_value(j)) + ...
                  z_std * cosd(angle_of_attack_value(j)));
% factor = 0.5 * wing area [m^2] * air density [kg/m]* air speed [m/s]^2              
        factor=(0.5*configuration_wing_area(i)*1.225*(8.333^2));
        drag_coef = drag./factor;
        lift_coef = lift./factor;
        drag_coef_std = drag_std./factor;
        lift_coef_std = lift_std./factor;
        drag_lift_table(i,j,1)=drag;
        drag_lift_table(i,j,2)=lift;
        drag_lift_table(i,j,3)=drag_std;
        drag_lift_table(i,j,4)=lift_std;
        drag_lift_table(i,j,5)=lift/drag;
        drag_lift_table(i,j,6)=drag_coef;
        drag_lift_table(i,j,7)=lift_coef;
        drag_lift_table(i,j,8)=drag_coef_std;
        drag_lift_table(i,j,9)=lift_coef_std;
        
        figure('DefaultAxesFontSize',16);
        set(gcf, 'Position',  [100, 100, 500, 500])
        
        subplot(3,1,1);
        plot(force_x);
        title("Recorded forces", 'Interpreter', 'none');
        xline(length(force_x)-1000,':r','LineWidth',2,'Alpha',1);
        xline(length(force_x)-1500,':r','LineWidth',2,'Alpha',1);
        yline(x_mean,':b','LineWidth',2,'Alpha',1)
        xlabel('sample []') 
        ylabel('SX [N]')
        
        subplot(3,1,2);
        plot(force_z);
        xline(length(force_z)-1000,':r','LineWidth',2,'Alpha',1);
        xline(length(force_z)-1500,':r','LineWidth',2,'Alpha',1);
        yline(z_mean,':b','LineWidth',2,'Alpha',1);
        xlabel('sample []') 
        ylabel('SZ [N]') 
        
        subplot(3,1,3);
        plot([0,sind(angle_of_attack_value(j))*z_mean], ...
             [0,cosd(angle_of_attack_value(j))*z_mean],'-','LineWidth',2);
        title("Force projections", 'Interpreter', 'none');
        hold on;
        plot([0,cosd(angle_of_attack_value(j))*x_mean], ...
             [0,-sind(angle_of_attack_value(j))*x_mean],'-','LineWidth',2);
        hold on;
        plot([0,drag],[0,0],'-','LineWidth',2);
        hold on;
        plot([0,0],[0,lift],'-','LineWidth',2);

        xlim = get(gca,'XLim');
        xlim(1) = xlim(1)-0.2;
        xlim(2) = xlim(2)+0.2;
        ylim = get(gca,'YLim');
        ylim(1) = ylim(1)-0.2;
        ylim(2) = ylim(2)+0.2;            
        set(gca,'XLim',xlim,'YLim',ylim)

        axis equal;
        xlabel('WX [N]') 
        ylabel('WZ [N]')
        legend('mean z','mean x','drag','lift', 'Interpreter', 'none', ...
               'Location',[0.805446429476142 0.139344851163147 ...
               0.151785712476288 0.146428567454929])
    end
end
%% Plot of lift and drag coefficients for elytras

ms = 5;   %markersize
lw = 1.5; %linewidth
fs = 17;  %fontsize
figure();

subplot(2,1,1);
errorbar(angle_of_attack_value,drag_lift_table(5,:,7), ...
         drag_lift_table(5,:,9),'o:','Linewidth',lw,'color','#27AE60', ...
         'MarkerEdgeColor','#27AE60','MarkerFaceColor','#27AE60', ...
         'MarkerSize',ms)
hold on;
errorbar(angle_of_attack_value,drag_lift_table(5,:,6), ...
         drag_lift_table(5,:,8),'d-.','Linewidth',lw,'color','#27AE60', ...
         'MarkerEdgeColor','#27AE60','MarkerFaceColor','w','MarkerSize',ms)
hold on;
errorbar(angle_of_attack_value,drag_lift_table(6,:,7), ...
         drag_lift_table(6,:,9),'o:','Linewidth',lw,'color','#E74C3C', ...
         'MarkerEdgeColor','#E74C3C','MarkerFaceColor','#E74C3C', ...
         'MarkerSize',ms)
hold on;
errorbar(angle_of_attack_value,drag_lift_table(6,:,6), ...
    drag_lift_table(6,:,8),'d-.','Linewidth',lw,'color','#E74C3C', ...
    'MarkerEdgeColor','#E74C3C','MarkerFaceColor','w','MarkerSize',ms)
hold on;
errorbar(angle_of_attack_value,drag_lift_table(7,:,7), ...
         drag_lift_table(7,:,9),'o:','Linewidth',lw,'color','#2980B9', ...
         'MarkerEdgeColor','#2980B9','MarkerFaceColor','#2980B9', ...
         'MarkerSize',ms)
hold on;
errorbar(angle_of_attack_value,drag_lift_table(7,:,6), ...
         drag_lift_table(7,:,8),'d-.','Linewidth',lw,'color','#2980B9', ...
         'MarkerEdgeColor','#2980B9','MarkerFaceColor','w','MarkerSize',ms)
hold on;
%Caged drones
yline(0.83,'o:','Linewidth',lw,'color','#2C3E50','Linewidth',3)
hold on; 
%Legged cuboid structures
yline(0.92,'o:','Linewidth',lw,'color','#8E44AD','Linewidth',3)
ylabel('Lift and Drag Coefficients');
axis([-5 18 -0.5 1.25]);
xticks(angle_of_attack_value)
yticks([-0.5:0.25:1.25])
legend('17 cm Elytra $-$ Hind-Wing $C_L$', ...
       '17 cm Elytra $-$ Hind-Wing $C_D$', ...
       '14 cm Elytra $-$ Hind-Wing $C_L$', ...
       '14 cm Elytra $-$ Hind-Wing $C_D$', ...
       '11 cm Elytra $-$ Hind-Wing $C_L$', ...
       '11 cm Elytra $-$ Hind-Wing $C_D$','Caged Drones $C_D$', ...
       'Legged and Elongated Protrusion Drones $C_D$', 'Interpreter', ...
       'latex','Location','SE','NumColumns',2)
grid off
set(gcf,'color','w');
set(gca,'DataAspectRatio', [5.75 1 1]);
set(gca,'FontName','Times New Roman');
set(gca,'FontSize',fs)
print -depsc LiftDragCoef;

%% Elytra and hind-wings measured lift/drag ratios on same plot

additive_model_lift_170mm= (drag_lift_table(1,:,2) * ...
    configuration_wing_area(1)+ drag_lift_table(5,:,2)* ...
    configuration_wing_area(5))/(configuration_wing_area(1)+ ...
    configuration_wing_area(5));
measurement_lift_170mm= drag_lift_table(2,:,2);
additive_model_lift_140mm= (drag_lift_table(1,:,2)* ...
    configuration_wing_area(1)+ drag_lift_table(6,:,2)* ...
    configuration_wing_area(5))/(configuration_wing_area(1)+ ...
    configuration_wing_area(6));
measurement_lift_140mm= drag_lift_table(3,:,2);
additive_model_lift_110mm= (drag_lift_table(1,:,2)* ...
    configuration_wing_area(1)+ drag_lift_table(7,:,2)* ...
    configuration_wing_area(5))/(configuration_wing_area(1)+ ...
    configuration_wing_area(7));
measurement_lift_110mm= drag_lift_table(4,:,2);

additive_model_drag_170mm= (drag_lift_table(1,:,1)* ...
    configuration_wing_area(1)+ drag_lift_table(5,:,1)* ...
    configuration_wing_area(5))/(configuration_wing_area(1)+ ...
    configuration_wing_area(5));
measurement_drag_170mm = drag_lift_table(2,:,1);
additive_model_drag_140mm= (drag_lift_table(1,:,1)* ...
    configuration_wing_area(1)+ drag_lift_table(6,:,1)* ...
    configuration_wing_area(5))/(configuration_wing_area(1)+ ...
    configuration_wing_area(6));
measurement_drag_140mm =drag_lift_table(3,:,1);
additive_model_drag_110mm= (drag_lift_table(1,:,1)* ...
    configuration_wing_area(1)+ drag_lift_table(7,:,1)* ...
    configuration_wing_area(5))/(configuration_wing_area(1)+ ...
    configuration_wing_area(7));
measurement_drag_110mm =drag_lift_table(4,:,1);

ld_additive_model_1 = additive_model_lift_170mm./additive_model_drag_170mm; 
ld_measurement_1 = measurement_lift_170mm./measurement_drag_170mm;
ld_additive_model_2 = additive_model_lift_140mm./additive_model_drag_140mm;
ld_measurement_2 = measurement_lift_140mm./measurement_drag_140mm;
ld_additive_model_3 = additive_model_lift_110mm./additive_model_drag_110mm;
ld_measurement_3 = measurement_lift_110mm./measurement_drag_110mm;

plot(angle_of_attack_value,ld_measurement_1,'-o','Linewidth',lw,'color',...
    '#27AE60')
hold on
plot(angle_of_attack_value,ld_measurement_2,'-o','Linewidth',lw,'color',...
    '#E74C3C')
hold on
plot(angle_of_attack_value,ld_measurement_3,'-o','Linewidth',lw,'color',...
    '#2980B9')
hold on
plot(angle_of_attack_value,drag_lift_table(1,:,5),'-o','Linewidth',lw, ...
    'color','#2C3E50')
hold on
xlabel('Angle of Attack (Degrees)');
ylabel('Lift/Drag Ratio');
axis([-5 18 -5 5]);
xticks(angle_of_attack_value)
yticks([-5:1:5])
legend('17 cm Elytra $-$ Hind-Wing','14 cm Elytra $-$ Hind-Wing', ...
    '11 cm Elytra $-$ Hind-Wing','Hind-Wings', 'Interpreter', 'latex', ...
    'Location','SE')
grid off
set(gcf,'color','w');
set(gca,'DataAspectRatio', [1 1 1]);
set(gca,'FontName','Times New Roman');
set(gca,'FontSize',fs)

%% Elytra and hind-wings measured and modeled lift/drag ratios
figure();
subplot(3,1,1);
plot(angle_of_attack_value,ld_measurement_1,'-o','Linewidth',lw, ...
     'color','#27AE60')
hold on;
plot(angle_of_attack_value,ld_additive_model_1,'--o','Linewidth',lw, ...
     'color','#27AE60')
xlabel('Angle of Attack (Degrees)');
ylabel('Lift/Drag Ratio');
axis([-5 18 -5 5]);
xticks(angle_of_attack_value)
yticks([-5:1:5])
legend('17 cm Elytra $-$ Hind-Wing measurement', ...
       '17 cm Elytra $-$ Hind-Wings model','Interpreter', 'latex', ...
       'Location','SE')

grid off
set(gcf,'color','w');
set(gca,'DataAspectRatio', [1.5 1 1]);
set(gca,'FontName','Times New Roman');
set(gca,'FontSize',fs)

subplot(3,1,2);
plot(angle_of_attack_value,ld_measurement_2,'-o','Linewidth',lw, ...
     'color','#E74C3C')
hold on;
plot(angle_of_attack_value,ld_additive_model_2,'--o','Linewidth',lw, ...
     'color','#E74C3C')
xlabel('Angle of Attack (Degrees)');
ylabel('Lift/Drag Ratio');
axis([-5 18 -5 5]);
xticks(angle_of_attack_value)
yticks([-5:1:5])
legend('14 cm Elytra $-$ Hind-Wing measurement', ....
       '14 cm Elytra $-$ Hind-Wings model','Interpreter', 'latex', ...
       'Location','SE')
grid off
set(gcf,'color','w');
set(gca,'DataAspectRatio', [1.5 1 1]);
set(gca,'FontName','Times New Roman');
set(gca,'FontSize',fs)

subplot(3,1,3);
plot(angle_of_attack_value,ld_measurement_3,'-o','Linewidth',lw, ...
     'color','#2980B9')
hold on;
plot(angle_of_attack_value,ld_additive_model_3,'--o','Linewidth',lw, ...
     'color','#2980B9')
xlabel('Angle of Attack (Degrees)');
ylabel('Lift/Drag Ratio');
axis([-5 18 -5 5]);
xticks(angle_of_attack_value)
yticks([-5:1:5])
legend('11 cm Elytra $-$ Hind-Wing measurement', ...
       '11 cm Elytra $-$ Hind-Wings model','Interpreter', 'latex', ...
       'Location','SE')

grid off
set(gcf,'color','w');
set(gca,'DataAspectRatio', [1.5 1 1]);
set(gca,'FontName','Times New Roman');
set(gca,'FontSize',fs)
set(gcf,'position',[10,10,450,1000])
print -depsc LiftDragRatio;
