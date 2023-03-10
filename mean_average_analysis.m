clear all
close all
filename = '';
M = xlsread(filename);
N=size(M,2);

% extract mean signal DF/F0 from 90s (frame 179 to 190) 
newM=M(179:190,:);
meanSignal = mean(newM,1);

%for figure mean and SEM
trace = M(161:273,:);
tracemean = mean(trace,2);
traceSEM = std(trace,0,2)/sqrt(N);

%plot figure
hold on
x=1:size(trace,1);
A=shadedErrorBar(x,tracemean,traceSEM,'r-',2);
legend([A.mainLine],filename);

axis off;

plot([140 200], [-0.05 -0.05], 'k');
plot([140 140], [-0.05 0.15], 'k');
text(605, -0.045, 't (s)');
text(570, -0.06, '10');
text(520, 0.16, '\DeltaF/F');
text(500, 0.05, '0.2');
name=filename;
print(name, '-painters', '-depsc2');

Results_meansignal=[meanSignal];
xlswrite(strcat (filename, '_results'),Results_meansignal,'Sheet1');
