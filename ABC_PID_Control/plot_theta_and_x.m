function plot_theta_and_x(x_save, theta_save, ti, settling_time, tf, x_desire)
figure(1);
i = ti:settling_time:tf;
plot(i, theta_save);
xlabel('time (second) ');
ylabel('\theta (radian)');

figure(2);
plot(i, x_save,'r');
hold on;
plot(i, x_desire,'b');
xlabel('time (second) ');
ylabel('position');
legend('after control','command signal')
       
end
