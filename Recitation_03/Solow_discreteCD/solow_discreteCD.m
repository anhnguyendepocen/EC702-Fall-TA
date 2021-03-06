%%%%%%%%%%%%%
% solow_discreteCD.m
% Solves plain vanilla Solow model in discrete time (see example 1 in discussion 2)
% Stefano Pica
% Fall 2019
%%%%%%%%%%%%%

clear; close all; clc

% Model Parameters - annual calibration
s = 0.2;        %average share of real investment in real GDP (around 20%)
delta = 0.05;   %average ratio of depreciation to GDP (around 5%)
n = 0.02;       %population growth (around 2%)
g = 0.02;       %technology growth
alpha = 1/3;    %current level of capital share in the economy (around 33%)
A = 1;          %normalize labor to get technology per efficiency units
L = 1;          %normalize labor to get capital per efficiency units

% Plotting parameters
fsizenum = 14;
lwidnum = 2;

%time objects
T = 100;        %end of time
time = 1:T;     %grid of time periods

%preallocate vectors
k = NaN(1,T);       %capital per efficiency units
y = NaN(1,T);       %output per efficiency units
mpk = NaN(1,T);     %marginal product of capital
sharek = NaN(1,T);  %capital share

%SS quantities: analytical solution
k_ss = ( (s*A) / ( (1+n) * (1+g) - (1-delta) ) ) ^ ( 1 / (1-alpha) ); %SS capital per efficiency units
y_ss = prodfCD(k_ss, L, A, alpha); %SS output per efficiency units
mpk_ss =  mpkCD(k_ss, L, A, alpha); %SS marginal product of capital
sharek_ss = mpk_ss * k_ss / y_ss; %SS capital share

%first point in time
k(1) = 1; %initial condition on state variable
y(1) = prodfCD(k(1), L, A, alpha); %output
mpk(1) = mpkCD(k(1), L, A, alpha); %marginal product of capital
sharek(1) = mpk(1) * k(1) / y(1); %capital share

for t = 2:T %solve recursively law of motion
       k(t) = (1 / ( (1+n) * (1+g) ) ) * ( (1-delta) * k(t-1) + s * y(t-1) );
       y(t) = prodfCD(k(t), L, A, alpha);
       mpk(t) = mpkCD(k(t), L, A, alpha); 
       sharek(t) = mpk(t) * k(t) / y(t);
end


figure % plot series of interest
subplot(2,2,1);
plot(time, sharek, 'b', 'LineWidth', lwidnum), title('Capital Share'), xlabel('Time');
set(gca,'FontSize',fsizenum);

subplot(2,2,2);
plot(time, k, 'b', time, k_ss*ones(T),'--r', 'LineWidth', lwidnum), title('Capital per worker'), xlabel('Time');
legend('Capital','Steady State','Location','Southeast'), legend boxoff;
set(gca,'FontSize',fsizenum);

subplot(2,2,3);
plot(time, y, 'b', time, y_ss*ones(T),'--r', 'LineWidth', lwidnum), title('Output per worker'), xlabel('Time');
legend('Output','Steady State','Location','Southeast'), legend boxoff;
set(gca,'FontSize',fsizenum);

subplot(2,2,4);
plot(time, mpk, 'b', time, mpk_ss*ones(T),'--r', 'LineWidth', lwidnum), title('Marginal product of capital'), xlabel('Time');
legend('MPK','Steady State','Location','Northeast'), legend boxoff;
set(gca,'FontSize',fsizenum);
%print('solow_discrete','-djpeg')


