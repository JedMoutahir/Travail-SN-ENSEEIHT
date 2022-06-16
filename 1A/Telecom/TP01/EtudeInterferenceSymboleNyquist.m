close all;
clear;

%Information binaire a transmettre
NbBitsMessage = 1000;
Infomation = randi(2,1,NbBitsMessage) -1;

%-------------------------------------------------------------
%-----------------Sans canal de propagation-------------------
%-------------------------------------------------------------

%Mapping : binaire à moyenne nulle
mapped1 = Infomation*2-1;

%Surechantillonnage
Fe = 24000;
Te = 1/Fe;
L = length(mapped1);
nbSymboles = 2;
Rb = 3000;
Ts = nbSymboles/Rb;
Ns = floor(Ts/Te);
Tsignal = [0 : Te : (L*Ns-1)*Te];
signal1 = kron(mapped1, [1, zeros(1,Ns-1)]);

%Filtrage de mise en forme : retangulaire
rectangle = ones(1,Ns);
signal1Filtred= filter(rectangle,1,signal1);


%Filtrage de réception : retangulaire
rectangle = ones(1,Ns);
signal1Reception= filter(rectangle,1,signal1Filtred);

%Tracé signal reçu en fonction du temps
figure;
plot(Tsignal, signal1Reception);
title('signal 1 reçu');
xlabel('t en s');
ylabel('signal1Reception(t)');

%Calcul de la réponse impulsionnelle globale de la chaine de transmission
Trepimp = [0 : Te : 2*(Ns-1)*Te];
g = conv(rectangle, rectangle);

%Tracé de la réponse impulsionnelle globale de la chaine de transmission
figure;
plot(Trepimp, g);
title('réponse impulsionnelle globale de la chaine de transmission');
xlabel('t en s');
ylabel('g(t)');

%Tracé du diagramme de l oeil en sortie du filtre de réception
figure;
plot(reshape(signal1Reception,Ns,length(signal1Reception)/Ns));
title('diagramme de l oeil en sortie du filtre de réception');
xlabel('');
ylabel('');

%Echantillonnage du signal reçu (bon)
signalEch1 = signal1Reception(Ns:Ns:end);
signalBinRecu1 = signalEch1 >=0;

diff1 = sum(abs(Infomation - signalBinRecu1));
TEB1 = diff1/length(Infomation);
%Echantillonnage du signal reçu (mauvais)
signalEch2 = signal1Reception(3:Ns:end);
signalBinRecu2 = signalEch2 >=0;

diff2 = sum(abs(Infomation - signalBinRecu2));
TEB2 = diff2/length(Infomation);


%-------------------------------------------------------------
%-----------------Avec canal de propagation-------------------
%-------------------------------------------------------------

N = 10;
ordre = floor(N/2);
%Mapping : binaire à moyenne nulle
mapped1 = Infomation*2-1;

%Surechantillonnage
Fe = 24000;
Te = 1/Fe;
L = length(mapped1);
nbSymboles = 2;
Rb = 3000;
Ts = nbSymboles/Rb;
Ns = floor(Ts/Te);
Tsignal = [0 : Te : (L*Ns-1)*Te];
signal1 = [kron(mapped1, [1, zeros(1,Ns-1)]) zeros(1,ordre)];


%Filtrage de mise en forme : retangulaire
rectangle = ones(1,Ns);
signal1Filtred = filter(rectangle,1,signal1);

%------------------------BW = 8000Hz------------------------%
%Filtrage du canal BW = 8000Hz
fc = 8000;
hc = (2*fc/Fe)*sinc(2*(fc/Fe)*[-(N - 1)/2 : (N - 1)/2]);
signalCanal = filter(hc, 1, signal1Filtred);

%Filtrage de réception : retangulaire
rectangle = ones(1,Ns);
signal1Reception = filter(rectangle,1,signalCanal);

%Calcul de la réponse impulsionnelle globale de la chaine de transmission
g = conv(conv(rectangle, hc), rectangle);
Trepimp = [0 : Te : (length(g)-1)*Te];

%Tracé de la réponse impulsionnelle globale de la chaine de transmission
figure;
plot(Trepimp, g);
title('réponse impulsionnelle globale de la chaine de transmission : BW = 8000Hz');
xlabel('t en s');
ylabel('g(t)');

%Tracé du diagramme de l oeil en sortie du filtre de réception
figure;
%plot(reshape(signal1Reception,Ns,floor(length(signal1Reception)/Ns)));
title('diagramme de l oeil en sortie du filtre de réception');
xlabel('');
ylabel('');

Np = 4096;
H = fftshift(fft(rectangle, Np));
Hr = fftshift(fft(rectangle, Np));
Hc = fftshift(fft(hc, Np));
F = linspace(-Fe/2,Fe/2,Np);

figure;
plot(F, abs(H.*Hr)/max(abs(H.*Hr)));
hold on;
plot(F, abs(Hc)/max(abs(Hc)));
legend('|H(f)Hr(f)|','|Hc(f)|');
title('|H(f)Hr(f)| et |Hc(f)| avec BW = 8000Hz');
xlabel('f en Hz');
ylabel('');


%Echantillonnage du signal reçu
signal1Reception = signal1Reception(ordre:end);
signalEch1 = signal1Reception(Ns:Ns:end);
signalBinRecu1 = signalEch1 >=0;

diff1 = sum(abs(Infomation - signalBinRecu1));
TEB1 = diff1/length(Infomation);


%------------------------BW = 1000Hz------------------------%
%Filtrage du canal BW = 1000Hz
fc = 1000;
hc = (2*fc/Fe)*sinc(2*(fc/Fe)*[-(N - 1)/2 : (N - 1)/2]);
signalCanal = filter(hc, 1, signal1Filtred);

%Filtrage de réception : retangulaire
rectangle = ones(1,Ns);
signal1Reception = filter(rectangle,1,signalCanal);

%Calcul de la réponse impulsionnelle globale de la chaine de transmission
g = conv(conv(rectangle, hc), rectangle);
Trepimp = [0 : Te : (length(g)-1)*Te];

%Tracé de la réponse impulsionnelle globale de la chaine de transmission
figure;
plot(Trepimp, g);
title('réponse impulsionnelle globale de la chaine de transmission : BW = 1000Hz');
xlabel('t en s');
ylabel('g(t)');

%Tracé du diagramme de l oeil en sortie du filtre de réception
figure;
%plot(reshape(signal1Reception,Ns,length(signal1Reception)/Ns));
title('diagramme de l oeil en sortie du filtre de réception');
xlabel('');
ylabel('');

Np = 4096;
H = fftshift(fft(rectangle, Np));
Hr = fftshift(fft(rectangle, Np));
Hc = fftshift(fft(hc, Np));
F = linspace(-Fe/2,Fe/2,Np);

figure;
plot(F, abs(H.*Hr)/max(abs(H.*Hr)));
hold on;
plot(F, abs(Hc)/max(abs(Hc)));
legend('|H(f)Hr(f)|','|Hc(f)|');
title('|H(f)Hr(f)| et |Hc(f)| avec BW = 1000Hz');
xlabel('f en Hz');
ylabel('');


%Echantillonnage du signal reçu
signal1Reception = signal1Reception(ordre:end);
signalEch1 = signal1Reception(Ns:Ns:end);
signalBinRecu1 = signalEch1 >=0;

diff2 = sum(abs(Infomation - signalBinRecu1));
TEB2 = diff2/length(Infomation);