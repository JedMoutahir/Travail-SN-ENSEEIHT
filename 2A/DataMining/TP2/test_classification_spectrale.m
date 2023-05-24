clear;
close all;

% test 
load('ToyExample.mat')
for sig = [0.1 0.3 0.7 0.9 1 10 50 100]
    clusters = classification_spectrale(Data, 2, sig);
    figure()
    subplot(1,3,1)
    image(Data(:,1), 'CDataMapping', 'scaled')
    subplot(1,3,2)
    image(Data(:,2), 'CDataMapping', 'scaled')
    subplot(1,3,3)
    image(clusters, 'CDataMapping', 'scaled')
end