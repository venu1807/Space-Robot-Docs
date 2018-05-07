function complete_state
% Discrete-time extended Kalman filter simulation for two-phase 

MeasNoise = 0.01; % standard deviation of measurement noise (amps)

Q =[MeasNoise^2 0 0 0 0 0 0 0 0; 
    0 MeasNoise^2 0 0 0 0 0 0 0; 
    0 0 MeasNoise^2 0 0 0 0 0 0; 
    0 0 0 MeasNoise^2 0 0 0 0 0; 
    0 0 0 0 MeasNoise^2 0 0 0 0;
    0 0 0 0 0 MeasNoise^2 0 0 0;
    0 0 0 0 0 0 MeasNoise^2 0 0;
    0 0 0 0 0 0 0 MeasNoise^2 0;
    0 0 0 0 0 0 0 0 MeasNoise^2] % Measurement noise covariance

xdotNoise = [0.1; 0.1; 0.1; 0.1; 0.1 ; 0.1; 0.1; 0.1; 0.1].*10^-1;
% Define the continuous-time process noise covariance Q
R = [xdotNoise(1) 0 0 0 0 0 0 0 0; 
     0 xdotNoise(2) 0 0 0 0 0 0 0; 
     0 0 xdotNoise(3) 0 0 0 0 0 0; 
     0 0 0 xdotNoise(4) 0 0 0 0 0;
     0 0 0 0 xdotNoise(5) 0 0 0 0;
     0 0 0 0 0 xdotNoise(6) 0 0 0;
     0 0 0 0 0  0 xdotNoise(6) 0 0;
     0 0 0 0 0 0  0 xdotNoise(6) 0;
     0 0 0 0 0 0 0  0 xdotNoise(6)]; 
 
% Ppost = 1*eye(6); % Initial state estimation covariance % dt = 0.1; % Simulation step size (seconds

P = 10*eye(9);


T = 0.1; % how often measurements are obtained

tf = 30; % Simulation length
 
x = [0; 0; 0; 0; 0; 0; 0; 0; 0]; % Initial state
% xhat = [-6.917249e-08;	3.492230e-07	;0	;0;0;4.173033e-04 ]; % Initial state estimate
% xhat=[0;0;0;0;0;0];
xhat=x;

% xpost=x;
% w = 2 * pi; % Control input frequency (rad/sec)
% Q = Q * T; % discrete-time process noise covariance
 
dtPlot = 0; % How often to plot results
tPlot = -inf; % Most recent time at which data was saved for plotting
 
% Initialize arrays for plotting at the end of the program
xArray = []; % true state
xhatArray = []; % estimated state
trPArray = []; % trace of estimation error covariance
tArray = []; % time array

u=load('statevar.dat');

pp=0;
% Begin simulation loop
for t = 0 : T : tf
    pp=pp+1;
    y =eye(9)* [u(pp,6); u(pp,5);u(pp,4);u(pp,9); u(pp,10);u(pp,11);u(pp,14);u(pp,13);u(pp,12)] ;
%     + MeasNoise.*randn(6,1) ; % noisy measurement
%     + MeasNoise * randn(6,1); % noisy measurement
    if t >= tPlot + dtPlot
            % Save data for plotting
       tPlot = t + dtPlot - eps;
       xArray = [xArray x];
%        xhatArray = [xhatArray xpost];
%        trPArray = [trPArray trace(Ppost)];
       xhatArray = [xhatArray xhat];
       trPArray = [trPArray trace(P)];
       tArray = [tArray t];
    end
  
        
    thin=[0.3803;   -0.6198;    1.2867];%60
    thf=[-pi/2; -pi/2; -pi/2];
    Tp=tf;
    n=3;
    for i=1:n-1
            thi(i,1)=thin(i)+((thf(i)-thin(i))/Tp)*(t-(Tp/(2*pi))*sin((2*pi/Tp)*t));
            dthi(i,1)=((thf(i)-thin(i))/Tp)*(1-cos((2*pi/Tp)*t));
    end
    ua = thi(1);
    ub = thi(2);
        
    dth1=dthi(1);
    dth2=dthi(2);
        
    [prod_term,M]=verify_coupled_param_mtum(ua,ub);
        
    dth=[dth1;dth2];
     
    x_t=prod_term*dth;
    
    XI=(inv(M)*[x_t(6);x_t(5);x_t(4)])*T;
    
    kk=jacob
    
    xx=[XI;x_t];
%         xdot = xdot + xdotNoise ;
%         .* randn(4,1);
     x = x + xx;
%      x_t.*randn(9,1) ;
%      + xdotNoise.*randn(6,1) ;
        % rectangular integration
%      x(6) = mod(x(6), 2*pi); % keep the angle between 0 and 2*pi
        
%     A=eye(6);   

    G=eye(9);
    
%     C=eye(6);

    H=eye(9);
    
%     Ppriori=G*P*G'*R;

    % Compute the Kalman gain
    K = P * H' * inv(H * P * H' + Q);
    % Update the state estimate
    [prod_term]=verify_coupled_param_mtum(ua,ub);
%     
%     deltax=prod_term*dth;
%     deltax=eye(6)*xhat;
   
%      xpost = xpost + x + K * (y - [xpost(1); xpost(2);xpost(3);xpost(4);xpost(5);xpost(6)]);
%     xhat = xhat + K * (y - [xhat(1); xhat(2);xhat(3);xhat(4);xhat(5);xhat(6)]);
      
     xhat = xhat + x + K * (y - [xhat(1); xhat(2);xhat(3);xhat(4);xhat(5);xhat(6);xhat(7);xhat(8);xhat(9)]);


%      xpost = xpost + x + K * (y - [x(1); x(2);x(3);x(4);x(5);x(6)]);
    
    % keep the angle estimate between 0 and 2*pi
%     xpost(6) = mod(xpost(6), 2*pi); 
%      xhat(6) = mod(xhat(6), 2*pi); 
    % Update the estimation error covariance.
    % Don't delete the extra parentheses (numerical issues).
      P = G * ((eye(9) - K * H) * P) * G' + R;
     
     
%     P = G * ((eye(6) - K * H) * P) * G' +((eye(6) - K * H))* R;
%      P=(eye(6) - K * H)*Ppriori;
    
end
 
tArray;
xArray;
xhatArray
trPArray;

% Plot the results
close all;
figure(1); set(gcf,'Color','White');
 
subplot(3,1,1); hold on; box on;
plot(tArray, xArray(1,:), 'b-', 'LineWidth', 2);
plot(tArray, xhatArray(1,:), 'r:', 'LineWidth', 2)
plot(tArray, u(:,9), 'g:', 'LineWidth', 2)
set(gca,'FontSize',12);
xlabel('Time (Seconds)');ylabel('psi(rad))');
legend('True', 'Estimated','measured');
 
subplot(3,1,2); hold on; box on;
plot(tArray, xArray(2,:), 'b-', 'LineWidth', 2);
plot(tArray, xhatArray(2,:), 'r:', 'LineWidth', 2);
plot(tArray, u(:,10), 'g:', 'LineWidth', 2)
set(gca,'FontSize',12);
xlabel('Time (Seconds)');ylabel('theta(rad)');
legend('True', 'Estimated','measured');
 
subplot(3,1,3); hold on; box on;
plot(tArray, xArray(3,:), 'b-', 'LineWidth', 2);
plot(tArray, xhatArray(3,:), 'r:', 'LineWidth', 2);
plot(tArray, u(:,11), 'g:', 'LineWidth', 2);
set(gca,'FontSize',12); 
xlabel('Time (Seconds)'); ylabel('phi(rad)');
legend('True', 'Estimated','measured');

figure(2);set(gcf,'Color','White');
subplot(3,1,1); hold on; box on;
plot(tArray, xArray(7,:), 'b-', 'LineWidth', 2);
plot(tArray,xhatArray(7,:), 'r:', 'LineWidth', 2)
plot(tArray, u(:,12), 'g:', 'LineWidth', 2)
set(gca,'FontSize',12); 
xlabel('Time (Seconds)'); ylabel('dpsi(rad/sec)');
legend('True', 'Estimated','measured');
 
subplot(3,1,2); hold on; box on;
plot(tArray, xArray(8,:), 'b-', 'LineWidth', 2);
plot(tArray,xhatArray(8,:), 'r:', 'LineWidth', 2)
plot(tArray, u(:,13), 'g:', 'LineWidth', 2)
set(gca,'FontSize',12); 
xlabel('Time (Seconds)'); ylabel('dtheta0(rad/sec)');
legend('True', 'Estimated','measured');

subplot(3,1,3); hold on; box on;
plot(tArray, xArray(9,:), 'b-', 'LineWidth', 2);
plot(tArray,xhatArray(9,:), 'r:', 'LineWidth', 2)
plot(tArray, u(:,14), 'g:', 'LineWidth', 2)
set(gca,'FontSize',12); 
xlabel('Time (Seconds)'); ylabel('dphi0(rad/sec)');
legend('True', 'Estimated','measured');

figure(3);set(gcf,'Color','White');
subplot(3,1,1); hold on; box on;
plot(tArray, xArray(4,:), 'b-', 'LineWidth', 2);
plot(tArray,xhatArray(4,:), 'r:', 'LineWidth', 2)
plot(tArray, u(:,9), 'g:', 'LineWidth', 2)
set(gca,'FontSize',12); 
xlabel('Time (Seconds)'); ylabel('dx0(m/sec)');
legend('True', 'Estimated','measured');
 
subplot(3,1,2); hold on; box on;
plot(tArray, xArray(5,:), 'b-', 'LineWidth', 2);
plot(tArray,xhatArray(5,:), 'r:', 'LineWidth', 2)
plot(tArray, u(:,10), 'g:', 'LineWidth', 2)
set(gca,'FontSize',12); 
xlabel('Time (Seconds)'); ylabel('dy0(m/sec)');
legend('True', 'Estimated','measured');

subplot(3,1,3); hold on; box on;
plot(tArray, xArray(6,:), 'b-', 'LineWidth', 2);
plot(tArray,xhatArray(6,:), 'r:', 'LineWidth', 2)
plot(tArray, u(:,11), 'g:', 'LineWidth', 2)
set(gca,'FontSize',12); 
xlabel('Time (Seconds)'); ylabel('dz0(m/sec)');
legend('True', 'Estimated','measured');

figure;
plot(tArray, trPArray); title('Trace(P)', 'FontSize', 12);
set(gca,'FontSize',12); set(gcf,'Color','White');
xlabel('Seconds');
 
% Compute the standard deviation of the estimation errors
N = size(xArray, 2);
N2 = round(N / 2);
xArray = xArray(:,N2:N);
xhatArray = xhatArray(:,N2:N);
iaEstErr = sqrt(norm(xArray(1,:)-xhatArray(1,:))^2 / size(xArray,2));
ibEstErr = sqrt(norm(xArray(2,:)-xhatArray(2,:))^2 / size(xArray,2));
wEstErr = sqrt(norm(xArray(3,:)-xhatArray(3,:))^2 / size(xArray,2));
thetaEstErr = sqrt(norm(xArray(4,:)-xhatArray(4,:))^2 / size(xArray,2));
theta1EstErr = sqrt(norm(xArray(5,:)-xhatArray(5,:))^2 / size(xArray,2));
theta2EstErr = sqrt(norm(xArray(6,:)-xhatArray(6,:))^2 / size(xArray,2));
thetaaEstErr = sqrt(norm(xArray(7,:)-xhatArray(7,:))^2 / size(xArray,2));
theta11EstErr = sqrt(norm(xArray(8,:)-xhatArray(8,:))^2 / size(xArray,2));
theta22EstErr = sqrt(norm(xArray(9,:)-xhatArray(9,:))^2 / size(xArray,2));


disp(['Std Dev of Estimation Errors = ',num2str(iaEstErr),', ', ...
    num2str(ibEstErr),', ',num2str(wEstErr),', ',num2str(thetaEstErr),', ',num2str(theta1EstErr),', ',num2str(theta2EstErr),', ',num2str(thetaaEstErr),', ',num2str(theta11EstErr),', ',num2str(theta22EstErr)]);
