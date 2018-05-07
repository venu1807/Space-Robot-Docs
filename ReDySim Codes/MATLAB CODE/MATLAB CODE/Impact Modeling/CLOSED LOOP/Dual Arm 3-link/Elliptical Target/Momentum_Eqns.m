clc;
clear all;

%function [JT,I,F,c]= Eqn_matrix_M(x0, y0, th0, th1, th2, th3, th4, th5, th6, dx0, dy0, dth0, dth1, dth2, dth3, dth4, dth5, dth6)

syms x0 y0 th0 th1 th2 th3 th4 th5 th6 th7 
syms dx0 dy0 dth0 dth1 dth2 dth3 dth4 dth5 dth6 dth7
syms fx fy tau0 tau1 tau2 tau3 tau4 tau5 tau6 tau7


m0=500;m1=10;m2=10;m3=10;m4=10;m5=10;m6=10; l0=1;l1=1;l2=1;l3=1;l4=1;l5=1;l6=1; lc0=.5*l0;lc1=.5*l1;lc2=.5*l2;lc3=.5*l3; lc4=.5*l4;lc5=.5*l5;lc6=.5*l6;  
Izz0=83.61; Izz1=1.05; Izz2=1.05; Izz3=1.05;Izz4=1.05; Izz5=1.05; Izz6=1.05;

J=vpa(zeros(1:6,1:9));

%%Base and Manp Vel

Ti=0; Tf=20;

TiTf1=Ti:.05:Tf

yy0=[0;0;0; 0.3803; -0.6198; 1.2867; pi-0.3803; 0.6198; -1.2867;0;0;0;0;0;0;0;0;0]; 



%yy0=[0;0;0; 0.698;-1.571; 1.047; 2.444 ;1.571; -1.047;0;0;0;0;0;0;0;0;0];
[T1,Y1] = ode45(@rigid_1,TiTf1,yy0);

Tii=Tf; Tff=30;
TiTf2=Tii:.05:Tff

n=length(T1)

[thdotf ttf tbf]=Impact_eqns()

yy00=[Y1(n,1:8).';0;0;tbf;thdotf(1:5)]; 

[T2,Y2] = ode45(@rigid_2,TiTf2,yy00);

T=[T1;T2];

Y(1:n,1:18)=Y1;
Y(n+1:length(T),1:8)=Y2(:,1:8);
Y(n+1:length(T),10:17)=Y2(:,11:18);

for i=1:n

    t=T(i)
    
  q(i,:)=Y(i,1:9)
  x0=q(i,1); y0=q(i,2); th0=q(i,3); th1=q(i,4); th2=q(i,5); th3=q(i,6); th4=q(i,7); th5=q(i,8); th6=q(i,9);  
    M =[                                                                                                                                                                                                                                                                                                                                                                                              m0 + m1 + m2 + m3 + m4 + m5 + m6,                                                                                                                                                                                                                                                                                                                                                                                                                           0,                                                                                                                                                                                                                                                                                                  - (m2*(2*l1*sin(th0 + th1) + 2*lc0*sin(th0) + 2*lc2*sin(th0 + th1 + th2)))/2 - (m5*(2*l4*sin(th0 + th4) - 2*lc0*sin(th0) + 2*lc5*sin(th0 + th4 + th5)))/2 - (m1*(2*lc1*sin(th0 + th1) + 2*lc0*sin(th0)))/2 - (m4*(2*lc4*sin(th0 + th4) - 2*lc0*sin(th0)))/2 - (m3*(2*lc3*sin(th0 + th1 + th2 + th3) + 2*l1*sin(th0 + th1) + 2*lc0*sin(th0) + 2*l2*sin(th0 + th1 + th2)))/2 - (m6*(2*lc6*sin(th0 + th4 + th5 + th6) + 2*l4*sin(th0 + th4) - 2*lc0*sin(th0) + 2*l5*sin(th0 + th4 + th5)))/2,                                                                                                                                                           - (m3*(2*lc3*sin(th0 + th1 + th2 + th3) + 2*l1*sin(th0 + th1) + 2*l2*sin(th0 + th1 + th2)))/2 - (m2*(2*l1*sin(th0 + th1) + 2*lc2*sin(th0 + th1 + th2)))/2 - lc1*m1*sin(th0 + th1),                                                                                                                           - (m3*(2*lc3*sin(th0 + th1 + th2 + th3) + 2*l2*sin(th0 + th1 + th2)))/2 - lc2*m2*sin(th0 + th1 + th2),                                                                -lc3*m3*sin(th0 + th1 + th2 + th3),                                                                                                                                                           - (m6*(2*lc6*sin(th0 + th4 + th5 + th6) + 2*l4*sin(th0 + th4) + 2*l5*sin(th0 + th4 + th5)))/2 - (m5*(2*l4*sin(th0 + th4) + 2*lc5*sin(th0 + th4 + th5)))/2 - lc4*m4*sin(th0 + th4),                                                                                                                           - (m6*(2*lc6*sin(th0 + th4 + th5 + th6) + 2*l5*sin(th0 + th4 + th5)))/2 - lc5*m5*sin(th0 + th4 + th5),                                                                -lc6*m6*sin(th0 + th4 + th5 + th6)
                                                                                                                                                                                                                                                                                                                                                                                                                             0,                                                                                                                                                                                                                                                                                                                                                                                            m0 + m1 + m2 + m3 + m4 + m5 + m6,                                                                                                                                                                                                                                                                                                    (m2*(2*l1*cos(th0 + th1) + 2*lc0*cos(th0) + 2*lc2*cos(th0 + th1 + th2)))/2 + (m5*(2*l4*cos(th0 + th4) - 2*lc0*cos(th0) + 2*lc5*cos(th0 + th4 + th5)))/2 + (m1*(2*lc1*cos(th0 + th1) + 2*lc0*cos(th0)))/2 + (m4*(2*lc4*cos(th0 + th4) - 2*lc0*cos(th0)))/2 + (m3*(2*lc3*cos(th0 + th1 + th2 + th3) + 2*l1*cos(th0 + th1) + 2*lc0*cos(th0) + 2*l2*cos(th0 + th1 + th2)))/2 + (m6*(2*lc6*cos(th0 + th4 + th5 + th6) + 2*l4*cos(th0 + th4) - 2*lc0*cos(th0) + 2*l5*cos(th0 + th4 + th5)))/2,                                                                                                                                                             (m2*(2*l1*cos(th0 + th1) + 2*lc2*cos(th0 + th1 + th2)))/2 + (m3*(2*lc3*cos(th0 + th1 + th2 + th3) + 2*l1*cos(th0 + th1) + 2*l2*cos(th0 + th1 + th2)))/2 + lc1*m1*cos(th0 + th1),                                                                                                                             (m3*(2*lc3*cos(th0 + th1 + th2 + th3) + 2*l2*cos(th0 + th1 + th2)))/2 + lc2*m2*cos(th0 + th1 + th2),                                                                 lc3*m3*cos(th0 + th1 + th2 + th3),                                                                                                                                                             (m5*(2*l4*cos(th0 + th4) + 2*lc5*cos(th0 + th4 + th5)))/2 + (m6*(2*lc6*cos(th0 + th4 + th5 + th6) + 2*l4*cos(th0 + th4) + 2*l5*cos(th0 + th4 + th5)))/2 + lc4*m4*cos(th0 + th4),                                                                                                                             (m6*(2*lc6*cos(th0 + th4 + th5 + th6) + 2*l5*cos(th0 + th4 + th5)))/2 + lc5*m5*cos(th0 + th4 + th5),                                                                 lc6*m6*cos(th0 + th4 + th5 + th6)
 - m2*(l1*sin(th0 + th1) + lc0*sin(th0) + lc2*sin(th0 + th1 + th2)) - m5*(l4*sin(th0 + th4) - lc0*sin(th0) + lc5*sin(th0 + th4 + th5)) - m1*(lc1*sin(th0 + th1) + lc0*sin(th0)) - m4*(lc4*sin(th0 + th4) - lc0*sin(th0)) - m3*(lc3*sin(th0 + th1 + th2 + th3) + l1*sin(th0 + th1) + lc0*sin(th0) + l2*sin(th0 + th1 + th2)) - m6*(lc6*sin(th0 + th4 + th5 + th6) + l4*sin(th0 + th4) - lc0*sin(th0) + l5*sin(th0 + th4 + th5)), m2*(l1*cos(th0 + th1) + lc0*cos(th0) + lc2*cos(th0 + th1 + th2)) + m5*(l4*cos(th0 + th4) - lc0*cos(th0) + lc5*cos(th0 + th4 + th5)) + m1*(lc1*cos(th0 + th1) + lc0*cos(th0)) + m4*(lc4*cos(th0 + th4) - lc0*cos(th0)) + m3*(lc3*cos(th0 + th1 + th2 + th3) + l1*cos(th0 + th1) + lc0*cos(th0) + l2*cos(th0 + th1 + th2)) + m6*(lc6*cos(th0 + th4 + th5 + th6) + l4*cos(th0 + th4) - lc0*cos(th0) + l5*cos(th0 + th4 + th5)), Izz0 + Izz1 + Izz2 + Izz3 + Izz4 + Izz5 + Izz6 + l1^2*m2 + l1^2*m3 + l2^2*m3 + l4^2*m5 + l4^2*m6 + l5^2*m6 + lc0^2*m1 + lc1^2*m1 + lc0^2*m2 + lc2^2*m2 + lc0^2*m3 + lc3^2*m3 + lc0^2*m4 + lc4^2*m4 + lc0^2*m5 + lc5^2*m5 + lc0^2*m6 + lc6^2*m6 + 2*l1*lc3*m3*cos(th2 + th3) + 2*l2*lc0*m3*cos(th1 + th2) + 2*l4*lc6*m6*cos(th5 + th6) - 2*l5*lc0*m6*cos(th4 + th5) + 2*lc0*lc2*m2*cos(th1 + th2) - 2*lc0*lc5*m5*cos(th4 + th5) + 2*l1*l2*m3*cos(th2) + 2*l4*l5*m6*cos(th5) + 2*l1*lc0*m2*cos(th1) + 2*l1*lc2*m2*cos(th2) + 2*l1*lc0*m3*cos(th1) + 2*l2*lc3*m3*cos(th3) - 2*l4*lc0*m5*cos(th4) + 2*l4*lc5*m5*cos(th5) - 2*l4*lc0*m6*cos(th4) + 2*l5*lc6*m6*cos(th6) + 2*lc0*lc1*m1*cos(th1) - 2*lc0*lc4*m4*cos(th4) + 2*lc0*lc3*m3*cos(th1 + th2 + th3) - 2*lc0*lc6*m6*cos(th4 + th5 + th6), Izz1 + Izz2 + Izz3 + l1^2*m2 + l1^2*m3 + l2^2*m3 + lc1^2*m1 + lc2^2*m2 + lc3^2*m3 + 2*l1*lc3*m3*cos(th2 + th3) + l2*lc0*m3*cos(th1 + th2) + lc0*lc2*m2*cos(th1 + th2) + 2*l1*l2*m3*cos(th2) + l1*lc0*m2*cos(th1) + 2*l1*lc2*m2*cos(th2) + l1*lc0*m3*cos(th1) + 2*l2*lc3*m3*cos(th3) + lc0*lc1*m1*cos(th1) + lc0*lc3*m3*cos(th1 + th2 + th3), Izz2 + Izz3 + l2^2*m3 + lc2^2*m2 + lc3^2*m3 + l1*lc3*m3*cos(th2 + th3) + l2*lc0*m3*cos(th1 + th2) + lc0*lc2*m2*cos(th1 + th2) + l1*l2*m3*cos(th2) + l1*lc2*m2*cos(th2) + 2*l2*lc3*m3*cos(th3) + lc0*lc3*m3*cos(th1 + th2 + th3), Izz3 + lc3^2*m3 + l1*lc3*m3*cos(th2 + th3) + l2*lc3*m3*cos(th3) + lc0*lc3*m3*cos(th1 + th2 + th3), Izz4 + Izz5 + Izz6 + l4^2*m5 + l4^2*m6 + l5^2*m6 + lc4^2*m4 + lc5^2*m5 + lc6^2*m6 + 2*l4*lc6*m6*cos(th5 + th6) - l5*lc0*m6*cos(th4 + th5) - lc0*lc5*m5*cos(th4 + th5) + 2*l4*l5*m6*cos(th5) - l4*lc0*m5*cos(th4) + 2*l4*lc5*m5*cos(th5) - l4*lc0*m6*cos(th4) + 2*l5*lc6*m6*cos(th6) - lc0*lc4*m4*cos(th4) - lc0*lc6*m6*cos(th4 + th5 + th6), Izz5 + Izz6 + l5^2*m6 + lc5^2*m5 + lc6^2*m6 + l4*lc6*m6*cos(th5 + th6) - l5*lc0*m6*cos(th4 + th5) - lc0*lc5*m5*cos(th4 + th5) + l4*l5*m6*cos(th5) + l4*lc5*m5*cos(th5) + 2*l5*lc6*m6*cos(th6) - lc0*lc6*m6*cos(th4 + th5 + th6), Izz6 + lc6^2*m6 + l4*lc6*m6*cos(th5 + th6) + l5*lc6*m6*cos(th6) - lc0*lc6*m6*cos(th4 + th5 + th6)
                                                                                                                                                                                                                                                               - m3*(lc3*sin(th0 + th1 + th2 + th3) + l1*sin(th0 + th1) + l2*sin(th0 + th1 + th2)) - m2*(l1*sin(th0 + th1) + lc2*sin(th0 + th1 + th2)) - lc1*m1*sin(th0 + th1),                                                                                                                                                                                                                                                               m2*(l1*cos(th0 + th1) + lc2*cos(th0 + th1 + th2)) + m3*(lc3*cos(th0 + th1 + th2 + th3) + l1*cos(th0 + th1) + l2*cos(th0 + th1 + th2)) + lc1*m1*cos(th0 + th1),                                                                                                                                                                                                                                                                                                                                                                                                                                                Izz1 + Izz2 + Izz3 + l1^2*m2 + l1^2*m3 + l2^2*m3 + lc1^2*m1 + lc2^2*m2 + lc3^2*m3 + 2*l1*lc3*m3*cos(th2 + th3) + l2*lc0*m3*cos(th1 + th2) + lc0*lc2*m2*cos(th1 + th2) + 2*l1*l2*m3*cos(th2) + l1*lc0*m2*cos(th1) + 2*l1*lc2*m2*cos(th2) + l1*lc0*m3*cos(th1) + 2*l2*lc3*m3*cos(th3) + lc0*lc1*m1*cos(th1) + lc0*lc3*m3*cos(th1 + th2 + th3),                                                                                                                                                          Izz1 + Izz2 + Izz3 + l1^2*m2 + l1^2*m3 + l2^2*m3 + lc1^2*m1 + lc2^2*m2 + lc3^2*m3 + 2*l1*lc3*m3*cos(th2 + th3) + 2*l1*l2*m3*cos(th2) + 2*l1*lc2*m2*cos(th2) + 2*l2*lc3*m3*cos(th3),                                                                                          m3*l2^2 + 2*m3*cos(th3)*l2*lc3 + l1*m3*cos(th2)*l2 + m2*lc2^2 + l1*m2*cos(th2)*lc2 + m3*lc3^2 + l1*m3*cos(th2 + th3)*lc3 + Izz2 + Izz3,                                   Izz3 + lc3^2*m3 + l1*lc3*m3*cos(th2 + th3) + l2*lc3*m3*cos(th3),                                                                                                                                                                                                                                                                                                                                           0,                                                                                                                                                                                                                               0,                                                                                                 0
                                                                                                                                                                                                                                                                                                                                 - m3*(lc3*sin(th0 + th1 + th2 + th3) + l2*sin(th0 + th1 + th2)) - lc2*m2*sin(th0 + th1 + th2),                                                                                                                                                                                                                                                                                                                                 m3*(lc3*cos(th0 + th1 + th2 + th3) + l2*cos(th0 + th1 + th2)) + lc2*m2*cos(th0 + th1 + th2),                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            Izz2 + Izz3 + l2^2*m3 + lc2^2*m2 + lc3^2*m3 + l1*lc3*m3*cos(th2 + th3) + l2*lc0*m3*cos(th1 + th2) + lc0*lc2*m2*cos(th1 + th2) + l1*l2*m3*cos(th2) + l1*lc2*m2*cos(th2) + 2*l2*lc3*m3*cos(th3) + lc0*lc3*m3*cos(th1 + th2 + th3),                                                                                                                                                                                                      m3*l2^2 + 2*m3*cos(th3)*l2*lc3 + l1*m3*cos(th2)*l2 + m2*lc2^2 + l1*m2*cos(th2)*lc2 + m3*lc3^2 + l1*m3*cos(th2 + th3)*lc3 + Izz2 + Izz3,                                                                                                                                                              m3*l2^2 + 2*m3*cos(th3)*l2*lc3 + m2*lc2^2 + m3*lc3^2 + Izz2 + Izz3,                                                              m3*lc3^2 + l2*m3*cos(th3)*lc3 + Izz3,                                                                                                                                                                                                                                                                                                                                           0,                                                                                                                                                                                                                               0,                                                                                                 0
                                                                                                                                                                                                                                                                                                                                                                                            -lc3*m3*sin(th0 + th1 + th2 + th3),                                                                                                                                                                                                                                                                                                                                                                                           lc3*m3*cos(th0 + th1 + th2 + th3),                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          Izz3 + lc3^2*m3 + l1*lc3*m3*cos(th2 + th3) + l2*lc3*m3*cos(th3) + lc0*lc3*m3*cos(th1 + th2 + th3),                                                                                                                                                                                                                                                                             Izz3 + lc3^2*m3 + l1*lc3*m3*cos(th2 + th3) + l2*lc3*m3*cos(th3),                                                                                                                                                                                            m3*lc3^2 + l2*m3*cos(th3)*lc3 + Izz3,                                                                                   m3*lc3^2 + Izz3,                                                                                                                                                                                                                                                                                                                                           0,                                                                                                                                                                                                                               0,                                                                                                 0
                                                                                                                                                                                                                                                               - m6*(lc6*sin(th0 + th4 + th5 + th6) + l4*sin(th0 + th4) + l5*sin(th0 + th4 + th5)) - m5*(l4*sin(th0 + th4) + lc5*sin(th0 + th4 + th5)) - lc4*m4*sin(th0 + th4),                                                                                                                                                                                                                                                               m5*(l4*cos(th0 + th4) + lc5*cos(th0 + th4 + th5)) + m6*(lc6*cos(th0 + th4 + th5 + th6) + l4*cos(th0 + th4) + l5*cos(th0 + th4 + th5)) + lc4*m4*cos(th0 + th4),                                                                                                                                                                                                                                                                                                                                                                                                                                                Izz4 + Izz5 + Izz6 + l4^2*m5 + l4^2*m6 + l5^2*m6 + lc4^2*m4 + lc5^2*m5 + lc6^2*m6 + 2*l4*lc6*m6*cos(th5 + th6) - l5*lc0*m6*cos(th4 + th5) - lc0*lc5*m5*cos(th4 + th5) + 2*l4*l5*m6*cos(th5) - l4*lc0*m5*cos(th4) + 2*l4*lc5*m5*cos(th5) - l4*lc0*m6*cos(th4) + 2*l5*lc6*m6*cos(th6) - lc0*lc4*m4*cos(th4) - lc0*lc6*m6*cos(th4 + th5 + th6),                                                                                                                                                                                                                                                                                                                                           0,                                                                                                                                                                                                                               0,                                                                                                 0,                                                                                                                                                          Izz4 + Izz5 + Izz6 + l4^2*m5 + l4^2*m6 + l5^2*m6 + lc4^2*m4 + lc5^2*m5 + lc6^2*m6 + 2*l4*lc6*m6*cos(th5 + th6) + 2*l4*l5*m6*cos(th5) + 2*l4*lc5*m5*cos(th5) + 2*l5*lc6*m6*cos(th6),                                                                                          m6*l5^2 + 2*m6*cos(th6)*l5*lc6 + l4*m6*cos(th5)*l5 + m5*lc5^2 + l4*m5*cos(th5)*lc5 + m6*lc6^2 + l4*m6*cos(th5 + th6)*lc6 + Izz5 + Izz6,                                   Izz6 + lc6^2*m6 + l4*lc6*m6*cos(th5 + th6) + l5*lc6*m6*cos(th6)
                                                                                                                                                                                                                                                                                                                                 - m6*(lc6*sin(th0 + th4 + th5 + th6) + l5*sin(th0 + th4 + th5)) - lc5*m5*sin(th0 + th4 + th5),                                                                                                                                                                                                                                                                                                                                 m6*(lc6*cos(th0 + th4 + th5 + th6) + l5*cos(th0 + th4 + th5)) + lc5*m5*cos(th0 + th4 + th5),                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            Izz5 + Izz6 + l5^2*m6 + lc5^2*m5 + lc6^2*m6 + l4*lc6*m6*cos(th5 + th6) - l5*lc0*m6*cos(th4 + th5) - lc0*lc5*m5*cos(th4 + th5) + l4*l5*m6*cos(th5) + l4*lc5*m5*cos(th5) + 2*l5*lc6*m6*cos(th6) - lc0*lc6*m6*cos(th4 + th5 + th6),                                                                                                                                                                                                                                                                                                                                           0,                                                                                                                                                                                                                               0,                                                                                                 0,                                                                                                                                                                                                      m6*l5^2 + 2*m6*cos(th6)*l5*lc6 + l4*m6*cos(th5)*l5 + m5*lc5^2 + l4*m5*cos(th5)*lc5 + m6*lc6^2 + l4*m6*cos(th5 + th6)*lc6 + Izz5 + Izz6,                                                                                                                                                              m6*l5^2 + 2*m6*cos(th6)*l5*lc6 + m5*lc5^2 + m6*lc6^2 + Izz5 + Izz6,                                                              m6*lc6^2 + l5*m6*cos(th6)*lc6 + Izz6
                                                                                                                                                                                                                                                                                                                                                                                            -lc6*m6*sin(th0 + th4 + th5 + th6),                                                                                                                                                                                                                                                                                                                                                                                           lc6*m6*cos(th0 + th4 + th5 + th6),                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          Izz6 + lc6^2*m6 + l4*lc6*m6*cos(th5 + th6) + l5*lc6*m6*cos(th6) - lc0*lc6*m6*cos(th4 + th5 + th6),                                                                                                                                                                                                                                                                                                                                           0,                                                                                                                                                                                                                               0,                                                                                                 0,                                                                                                                                                                                                                                                                             Izz6 + lc6^2*m6 + l4*lc6*m6*cos(th5 + th6) + l5*lc6*m6*cos(th6),                                                                                                                                                                                            m6*lc6^2 + l5*m6*cos(th6)*lc6 + Izz6,                                                                                   m6*lc6^2 + Izz6]
 
Ib=M(1:3,1:3);
Ibm=M(1:3,4:9);
Im=M(4:9,4:9);

    
P(:,i)= Ib*(Y(i,10:12).')+Ibm*(Y(i,13:18).')


end

figure(1)
plot(T1,P(1,:),'b',T1,P(2,:),'r',T1,P(3,:),'g')
hold on
ymin=-0.00004;
ymax=0.00004;
xmin=0;
xmax=max(T1);
axis([xmin,xmax,ymin,ymax])