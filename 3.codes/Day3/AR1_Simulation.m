%% Simulation of AR(1) Process

rho = 0.95;
sigma = 2;
N_sim = 100;


x_sim = zeros(N_sim+1,1);


rng(1)
error_vec = randn(N_sim,1);

for i = 2:N_sim+1
    x_sim(i) = rho*x_sim(i-1) + error_vec(i-1);
end

st_dev_est = std(error_vec);

%% Creation of Nice Figure

end_year_points = 12:12:N_sim;
years = 2000:(2000+length(end_year_points)-1);
legend_label = ['\rho = ' num2str(rho)];

fig=figure;
plot(1:N_sim,x_sim(2:end),'Linewidth',1.5)
title('Simulation: AR(1) Process')
ylabel('x_{SIM}')
xlabel('Time Period')
xticks(end_year_points)
xticklabels(years)
legend(legend_label,'Location','northwest')
legend boxoff

set(fig, 'Position', [40 40 600 400]);
set(fig,'Units','Inches');
pos = get(fig,'Position');
set(fig,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
filename = ['../Figure_rho_' num2str(rho) '.pdf'];
print(fig,filename,'-dpdf');


%% Exercise: Simulate an AR(2) Process
