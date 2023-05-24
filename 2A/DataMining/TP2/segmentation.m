clear;
close all;

load('DataTransverse.mat');
load('DataSagittale.mat');

DataTempsT = reshape(Image_DataT, 64*54,20);
DataTempsS = reshape(Image_DataS, 64*54,20);
k = 5;
sig = 1;
[~,n] = size(DataTempsT);

csT = classification_spectrale(DataTempsT, k, sig);
k = 6;
csS = classification_spectrale(DataTempsS, k, sig);

Image_DataT_cs = reshape(csT, 64, 54);
Image_DataS_cs = reshape(csS, 64, 54);

figure()
subplot(1,2,1)
image(Image_ROI_T, 'CDataMapping', 'scaled')
title("Real segmentation")
subplot(1,2,2)
image(Image_DataT_cs, 'CDataMapping', 'scaled')
title("Result segmentation")

figure()
subplot(1,2,1)
image(Image_ROI_S, 'CDataMapping', 'scaled')
title("Real segmentation")
subplot(1,2,2)
image(Image_DataS_cs, 'CDataMapping', 'scaled')
title("Result segmentation")