close all;
clear;

SNRdBliste = [0,1,2,3,4,5,6,7];

load("resultats4ASK.mat");
load("resultats8PSK.mat");
load("resultats16QAM.mat");
load("resultatsQPSK.mat");

%comparaison TEB avec TEB théorique
figure;
semilogy(SNRdBliste, TEB4ASK);
hold on;
semilogy(SNRdBliste, TEBQPSK);
semilogy(SNRdBliste, TEB8PSK);
semilogy(SNRdBliste, TEB16QAM);

title(['comparaison TEB en fonction du SNR en dB']);
legend('TEB 4ASK','TEB QPSK','TEB 8PSK','TEB 16QAM');
xlabel('SNRdB');
ylabel('TEB');
hold off;

%Tracé densité spectrale de puissance du signal transmis en fonction de la fréquence
Np = 4096;
Fe = 96000;
F = linspace(-Fe/2,Fe/2,Np);
figure;
semilogy(F, DSP4ASK);
hold on;
semilogy(F, DSPQPSK);
semilogy(F, DSP8PSK);
semilogy(F, DSP16QAM);

title(['comparaison densites spectrales']);
legend('DSP 4ASK','DSP QPSK','DSP 8PSK','DSP 16QAM');
xlabel('frequence (Hz)');
ylabel('DSP');
hold off;
