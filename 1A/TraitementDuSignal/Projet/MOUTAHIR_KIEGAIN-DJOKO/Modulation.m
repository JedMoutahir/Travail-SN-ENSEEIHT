close all;
clear;
load donnees1.mat;
load donnees2.mat;
fp1 = 0;
fp2 = 46000;
Fe = 240000;
Te = 1/Fe;
T = 40*1e-3;
F = 1/T;
L = length(bits_utilisateur1);
Ts = T/L;
Ns = Ts/Te;
%Tliste = [0 : T/L : (5*T*L-0.02)/L];
Tdonnee = [0 : Te : T - Te];
Tsignal = [0 : Te : 5*T - Te];
%----------------------------------------------------------------------
%-----------Construction du signal MF-TDMA à décoder-------------------
%----------------------------------------------------------------------

%signal 1 en temporel
nrz1 = -1 + 2*bits_utilisateur1;
int = repmat(nrz1,Ns,1);
m1 = int(:)';
%signal 2 en temporel
nrz2 = -1 + 2*bits_utilisateur2;
int = repmat(nrz2,Ns,1);
m2 = int(:)';

%tracé signaux en Temporel
figure;
subplot(2,1,1);
plot(Tdonnee, m1);
title('m1');
xlabel('t en s');
ylabel('m1(t)');
subplot(2,1,2);
plot(Tdonnee, m2);
title('m2');
xlabel('t en s');
ylabel('m2(t)');

%tracé signaux en Fréquenciel
Nf = 2^16;
Fdonnee = linspace(0, Fe, Nf);
M1 = pwelch(m1,[],[],Nf,Fe,'centered');
M2 = pwelch(m2,[],[],Nf,Fe,'centered');
figure;
subplot(2,1,1);
plot(Fdonnee, M1);
title('Densités spectrales de puissance de m1 et m2');
xlabel('f en Hz');
ylabel('Sm1(f)');
subplot(2,1,2);
plot(Fdonnee, M2);
xlabel('f en Hz');
ylabel('Sm2(f)');

%slot signal 1
sigslot1 = [zeros(1, Ns*L) , m1 , zeros(1, Ns*L) , zeros(1, Ns*L) , zeros(1, Ns*L)];

%slot signal 2
sigslot2 = [zeros(1, Ns*L) , zeros(1, Ns*L) , zeros(1, Ns*L) , zeros(1, Ns*L) , m2];

figure;
subplot(2,1,1);
plot(Tsignal, sigslot1);
title('signaux à envoyer sur porteuse pour chaque utilisateur');
xlabel('t en s');
ylabel('signal 1');
subplot(2,1,2);
plot(Tsignal, sigslot2);
xlabel('t en s');
ylabel('signal 2');

%porteuse 1
p1 = cos(2*pi*fp1*Tsignal);
%porteuse 2
p2 = cos(2*pi*fp2*Tsignal);

figure;
subplot(2,1,1);
plot(Tsignal, p1);
subplot(2,1,2);
plot(Tsignal, p2);


%signal modulé 1
x1 = sigslot1.*p1;
%signal modulé 2
x2 = sigslot2.*p2;

figure;
subplot(2,1,1);
plot(Tsignal, x1);
subplot(2,1,2);
plot(Tsignal, x2);

RsbDb = 5;
P = mean(abs(x1 + x2).^2);
Pbruit = P/(10^(RsbDb/10));
PbruitDb = 10*log(Pbruit);
x = x1 + x2 + wgn(1, length(x1), PbruitDb);

figure;
plot(Tsignal, x);
title('signal MF-TDMA à transmettre');
xlabel('t en s');
ylabel('signal');


%tracé signal en Fréquenciel
Nf = 2^16;
Fdonnee = linspace(-Fe/2, Fe/2, Nf);
X = pwelch(x,[],[],Nf,Fe,'centered');
figure;
semilogy(Fdonnee, X);
title('Densité spectrale de puisssance du signal MF-TDMA à transmettre');
xlabel('f en Hz');
ylabel('Ssignal(f)');


%----------------------------------------------------------------------
%-----------Mise en place du récepteur MF-TDMA-------------------------
%----------------------------------------------------------------------
fc = (fp1+fp2)/2;
ordre = 201;
N0 = (ordre-1)/2;
Tp = [-N0/Fe : 1/Fe : N0/Fe];
decalage = 2*N0;
x = [x(decalage+1:end), zeros(1,decalage)];
%-----Filtrage-signal-1---------

a = 1;
passeBas = 2*fc/Fe*sinc(2*fc*Tp);

Nf = 4096;
freq = linspace(0,Fe,Nf);
freqcentered = linspace(-Fe/2,Fe/2,Nf);
figure;
subplot(2,1,1);
plot(Tp,passeBas);
title('réponse impulsionnelle et réponse en fréquence du filtre');
xlabel('t en s');
ylabel('réponse impulsionnelle');
subplot(2,1,2);
plot(freqcentered,abs(fftshift(fft(passeBas,Nf))));
xlabel('f en Hz');
ylabel('réponse en fréquence');

x1filtred= filter(passeBas,a,x);
TFPasseBas = abs(fftshift(fft(passeBas,Nf)));
X = pwelch(x,[],[],Nf,Fe,'centered');
figure;
semilogy(freqcentered,TFPasseBas);
xlabel('f en Hz');
%ylabel('réponse en fréquence du filtre');
hold on;
semilogy(freqcentered, X);
xlabel('f en Hz');
ylabel('Signal et Filtre');
hold off;
title('Signal et Filtre Passe-Bas superposés en fréquenciel');

figure;
subplot(2,1,1);
plot(x1filtred);
subplot(2,1,2);
plot(x);
title('Filtrage signal 1 comparaison signal avant/après');

%-----Filtrage-signal-2---------

Dirac = [zeros(1,N0) , 1 , zeros(1,N0)];
passeHaut = Dirac - passeBas;

Nf = 4096;
figure;
subplot(2,1,1);
plot(Tp,passeHaut);
title('réponse impulsionnelle et réponse en fréquence du filtre');
xlabel('t en s');
ylabel('réponse impulsionnelle');
subplot(2,1,2);
plot(freqcentered,abs(fftshift(fft(passeHaut,Nf))));
xlabel('f en Hz');
ylabel('réponse en fréquence');

x2filtred= filter(passeHaut,a,x);
TFPasseHaut = abs(fftshift(fft(passeHaut,Nf)));
X = pwelch(x,[],[],Nf,Fe,'centered');
figure;
semilogy(freqcentered,TFPasseHaut);
hold on;
semilogy(freqcentered, X);
xlabel('f en Hz');
ylabel('Signal et Filtre');
hold off;
title('Signal et Filtre Passe-Haut superposés en fréquenciel');
figure;

subplot(2,1,1);
plot(x2filtred);
subplot(2,1,2);
plot(x);
title('Filtrage signal 2 comparaison signal avant/après');


figure;
subplot(3,1,1);
plot(Tsignal,x1filtred);
title('Comparaison signal avant/après filtrage');
xlabel('t en s');
ylabel('Signal après Filtre Passe-Bas');
subplot(3,1,2);
plot(Tsignal,x2filtred);
xlabel('t en s');
ylabel('Signal après Filtre Passe-Haut');
subplot(3,1,3);
plot(Tsignal,x);
xlabel('t en s');
ylabel('Signal avant Filtrage');

%----------------------------------------------------------------------
%--------------------Retour en bande de base---------------------------
%----------------------------------------------------------------------

ordre = 201;
N0 = (ordre-1)/2;
Tp = [-N0/Fe : 1/Fe : N0/Fe];

a = 1;

fc = fp2;
cos1 = cos(2*pi*fp1*Tsignal);
passeBas = 2*fc/Fe*sinc(2*fc*Tp);
x1Retour = filter(passeBas,a,x1filtred.*cos1);
TFPasseBas = abs(fftshift(fft(passeBas,Nf)));
X = pwelch(x1filtred.*cos1,[],[],Nf,Fe,'centered');
figure;
semilogy(freqcentered,TFPasseBas);
hold on;
semilogy(freqcentered, X);
hold off;
title('Filtrage apres demod signal 1 freq');

fc = fp2;
cos2 = cos(2*pi*fp2*Tsignal);
passeBas = 2*fc/Fe*sinc(2*fc*Tp);
x2Retour = filter(passeBas,a,x2filtred.*cos2);
TFPasseBas = abs(fftshift(fft(passeBas,Nf)));
X = pwelch(x2filtred.*cos2,[],[],Nf,Fe,'centered');
X1 = pwelch(x2Retour,[],[],Nf,Fe,'centered');
figure;
semilogy(freqcentered,TFPasseBas);
hold on;
%semilogy(freqcentered, X);
semilogy(freqcentered, X1);
hold off;
title('Filtrage apres demod signal 2 freq');


figure;
subplot(3,1,1);
plot(Tsignal,x1Retour);
title('signaux après retour en bande de base');
xlabel('t en s');
ylabel('Signal1');
subplot(3,1,2);
plot(Tsignal,x2Retour);
xlabel('t en s');
ylabel('Signal2');
subplot(3,1,3);
plot(Tsignal,x);
xlabel('t en s');
ylabel('Signal original');






%----------------------------------------------------------------------
%--------------------Détection du slot utile---------------------------
%----------------------------------------------------------------------
Pmax = 0;
iMax = 1;
for i=0:4
    xSlot = x1Retour(i*Ns*L+1:(i+1)*Ns*L);
    P = mean(abs(xSlot).^2);
    if(P > Pmax)
        Pmax = P;
        iMax = i;
    end
end
x1Slot = x1Retour(iMax*Ns*L:Ns*L*(iMax+1));

Pmax = 0;
iMax = 1;
for i=0:4
    xSlot = x2Retour(i*Ns*L+1:(i+1)*Ns*L);
    P = mean(abs(xSlot).^2);
    if(P > Pmax)
        Pmax = P;
        iMax = i;
    end
end
x2Slot = x2Retour(iMax*Ns*L:Ns*L*(iMax+1));



SignalFiltre=filter(ones(1,Ns),1,x1Slot) ;
SignalEchantillonne=SignalFiltre(Ns :Ns :end) ;
BitsRecuperes1=(sign(SignalEchantillonne)+1)/2 ;

SignalFiltre=filter(ones(1,Ns),1,x2Slot) ;
SignalEchantillonne=SignalFiltre(Ns :Ns :end) ;
BitsRecuperes2=(sign(SignalEchantillonne)+1)/2 ;


bin2str(BitsRecuperes1)
bin2str(BitsRecuperes2)

diff1 = sum(abs(BitsRecuperes1-bits_utilisateur1));
diff2 = sum(abs(BitsRecuperes2-bits_utilisateur2));

taux = (diff1+diff2)/(2*length(BitsRecuperes1))

