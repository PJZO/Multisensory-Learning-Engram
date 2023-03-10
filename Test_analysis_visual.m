clear all
close all
filename = '';
M = xlsread(filename);

%lighttrace is in the table first column
lighttrace=M(:,1);

%every value in odourtrace >500 corresponding to light presentation will 
%equal one
lighttrace(lighttrace(:)>500)=1;

%for visualization of light and signal on a figure, light trace value
%of light presentation equal zero and air presentation will equal minus one
lighttrace=lighttrace-1;

%ASAP trace is in the table from the second column to the end with dff1,
%dff2 for the two light presentation normalized to 
%different f0 every two columm for each fly 
trace1=M(:,2:2:end);
trace2=M(:,3:2:end);

traceCS_plus=mean(trace1,2);
traceCS_minus=mean(trace2,2);

data=size(M,2);
N=(data-1)/3;

lightframes=find(lighttrace(:)==0);
light1frames=find(lighttrace(1:250)==0);
light2frames=find(lighttrace(250:480)==0)+249;

% creating a new matrix for each light presentation
Light_plus = trace1(light1frames,:);
Light_minus = trace2(light2frames,:);

% extract mean DF/F0 during CS+ and CS-
meanLight_plus = mean(Light_plus (1:11,:));
meanLight_minus = mean(Light_minus (1:11,:));

% mean SEM DF/F0 during CS+ and CS-
meanLight_plusSEM = std(Light_plus (1:11,:))/sqrt(N);
meanLight_minusnSEM = std(Light_minus (1:11,:))/sqrt(N);

% extract integral_AUC DF/F0 during CS+ and CS-
Light_plusAUC = trapz(Light_plus);
Light_minusAUC = trapz(Light_minus);

% extract mean integral DF/F0 during CS+ and CS-
meanLight_plusAUC = mean(trapz(Light_plus));
meanLight_minusAUC = mean(trapz(Light_minus));

% calculate SEM of integral DF/F0 during CS+ and CS-
meanLight_plusAUCSEM = std(Light_plusAUC)/sqrt(N);
meanLight_minusAUCSEM = std(Light_minusAUC)/sqrt(N);

%for figure mean and SEM
Light_CSplus = trace1(161:261,:);
Light_CSminus = trace2(368:468,:);

Light_plusframemean = mean(Light_CSplus,2);
Light_minusframemean = mean(Light_CSminus,2);

Light_plusframeSEM = std(Light_CSplus,0,2)/sqrt(N);
Light_minusframeSEM = std(Light_CSminus,0,2)/sqrt(N);

%%
hold on

x=1:size(Light_CSplus,1);
y=1:size(Light_CSminus,1);

A=shadedErrorBar(x,Light_plusframemean,Light_plusframeSEM,'r-',2);
B=shadedErrorBar(y,Light_minusframemean,Light_minusframeSEM,'b-',2);

legend([A.mainLine,B.mainLine],'CS+','CS-');

axis off;

plot([94 100], [0.5 0.5], 'k');
plot([94 94], [0.5 0.7], 'k');
plot ([20 50], [-0.1 -0.1], 'k', 'LineWidth', 2);
text(101, 0.51, 't (s)');
text(96, 0.45, '1');
text(89, 0.75, '\DeltaF/F');
text(87, 0.6, '0.2');
name=filename;
print(name, '-painters', '-depsc2');

%%
Results_meanLight_plus=[meanLight_plus];
Results_meanLight_minus=[meanLight_minus];
Results_Light_plusInt=[Light_plusAUC];
Results_Light_minusInt=[Light_minusAUC];
xlswrite(strcat (filename, '_results'),Results_meanLight_plus,'Sheet1');
xlswrite(strcat (filename, '_results'),Results_meanLight_minus,'Sheet2');
xlswrite(strcat (filename, '_results'),Results_Light_plusInt,'Sheet3');
xlswrite(strcat (filename, '_results'),Results_Light_minusInt,'Sheet4');

