clear all
close all
filename = '';
M = xlsread(filename);

%odourtrace is in the table first column
odourtrace=M(:,1);

%every value in odourtrace >500 corresponding to odour presentation will 
%equal one
odourtrace(odourtrace(:)>500)=1;

%for visualization of odour and signal on a figure, odour trace value
%of odour presentation equal zero and air presentation will equal minus one
odourtrace=odourtrace-1;

%ASAP trace is in the table from the second column to the end with dff1,
%dff2for the two odour presentation normalized to 
%different f0 every two columm for each fly 
trace1=M(:,2:2:end);
trace2=M(:,3:2:end);

traceCS_plus=mean(trace1,2);
traceCS_minus=mean(trace2,2);

data=size(M,2);
N=(data-1)/3;

odourframes=find(odourtrace(:)==0);
odour1frames=find(odourtrace(1:250)==0);
odour2frames=find(odourtrace(250:480)==0)+249;

% creating a new matrix for each odour presentation
CS_plus = trace1(odour1frames,:);
CS_minus = trace2(odour2frames,:);

% extract mean DF/F0 during CS+ and CS-
meanCS_plus = mean(CS_plus);
meanCS_minus = mean(CS_minus);

% mean SEM DF/F0 during CS+ and CS-
meanCS_plusSEM = std(CS_plus)/sqrt(N);
meanCS_minusSEM = std(CS_minus)/sqrt(N);

% extract integral_AUC DF/F0 during CS+ and CS-
CS_plusAUC = trapz(CS_plus);
CS_minusAUC = trapz(CS_minus);

% extract mean integral_AUC DF/F0 during CS+ and CS-
CS_plusAUCmean = mean(trapz(CS_plus));
CS_minusmean = mean(trapz(CS_minus));

% calculate SEM of integral DF/F0 during CS+ and CS-
CS_plusAUCSEM = std(CS_plusAUC)/sqrt(N);
CS_minusAUCSEM = std(CS_minusAUC)/sqrt(N);

%for figure mean and SEM
odourCS_plus = trace1(161:261,:);
odourCS_mius = trace2(368:468,:);

odourCS_plusframemean = mean(odourCS_plus,2);
odourCS_minusframemean = mean(odourCS_mius,2);

odourCS_plusframeSEM = std(odourCS_plus,0,2)/sqrt(N);
odourCS_minusframeSEM = std(odourCS_mius,0,2)/sqrt(N);

%%
hold on

x=1:size(odourCS_plus,1);
y=1:size(odourCS_mius,1);

A=shadedErrorBar(x,odourCS_plusframemean,odourCS_plusframeSEM,'r-',2);
B=shadedErrorBar(y,odourCS_minusframemean,odourCS_minusframeSEM,'b-',2);

legend([A.mainLine,B.mainLine],'CS+','CS-');

axis off;

plot([94 100], [0.5 0.5], 'k');
plot([94 94], [0.5 0.7], 'k');
plot ([20 50], [-0.1 -0.1], 'k', 'LineWidth', 2);
text(101, 0.51, 't (s)');
text(96, 0.45, '1');
text(89, 0.75, '-\DeltaF/F');
text(87, 0.6, '0.2');
name=filename;
print(name, '-painters', '-depsc2');

%%
Results_CS_plusAUC=[CS_plusAUC];
Results_CS_minusAUC=[CS_minusAUC];
xlswrite(strcat (filename, '_results'),Results_CS_plusAUC,'Sheet1');
xlswrite(strcat (filename, '_results'),Results_CS_minusAUC,'Sheet2');

