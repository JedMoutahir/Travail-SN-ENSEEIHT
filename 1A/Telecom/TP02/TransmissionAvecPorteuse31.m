close all;
clear;

%Information binaire a transmettre--------------(1)
NbBitsMessage = 10000;
Information = randi(2,1,NbBitsMessage) -1;

%-------------------------------------------------------------------------------------------------------
%-----------------Implantation de la chaine sur fréquence porteuse--------------------------------------
%-------------------------------------------------------------------------------------------------------

%Mapping : binaire à moyenne nulle-------------(1)
aK = Information(1:2:end)*2-1;
bK = Information(2:2:end)*2-1;
dK = aK + 1j*bK;

%Surechantillonnage----------------------------(1)
Fe = 10000;
fp = 2000;
Te = 1/Fe;
L = length(dK);
nbSymboles = 2;
Rb = 2000;
Ts = nbSymboles/Rb;
Ns = floor(Ts/Te);

%retard anticipé
span = 10;
retardFMF = span*Ns/2;
retardFR = span*Ns/2;
N = 101;
retardTotal = retardFR + retardFMF + (N-1)/2;

Tsignal = [0 : Te : (L*Ns-1 + retardTotal)*Te];
signalAvantFiltre = [kron(dK, [1, zeros(1,Ns-1)]), zeros(1, retardTotal)];

%Filtrage de mise en forme---------------------(1)
a = 0.35;
h = rcosdesign(a, span, Ns);
xe = filter(h,1,signalAvantFiltre);

%Tracé signal en phase en fonction du temps
figure;
plot(Tsignal, real(xe));
title('signal en phase en fonction du temps');
xlabel('t en s');
ylabel('RE[xe(t)]');

%Tracé signal en quadrature en fonction du temps
figure;
plot(Tsignal, imag(xe));
title('signal en quadrature en fonction du temps');
xlabel('t en s');
ylabel('IM[xe(t)]');

%Transposition de frequence-------------------(1)
xPorte = xe .* exp(1j*2*pi*fp*Tsignal);
x = real(xPorte);

%Tracé signal transmis en fonction du temps
figure;
plot(Tsignal, x);
title('signal transmis en fonction du temps');
xlabel('t en s');
ylabel('x(t)');

%Tracé densité spectrale de puissance du signal transmis en fonction de la fréquence
Np = 4096;
DSP = pwelch(x,[],[],Np,Fe,'centered');
F = linspace(-Fe/2,Fe/2,Np);
figure;
semilogy(F,DSP);
title('DSP  du signal modulé sur fréquence porteuse');
xlabel('f en Hz');
ylabel('DSPx(f)');


%Retour en bande de base-----------------------(1)
x1 = x .* cos(2*pi*fp*Tsignal);
x2 = x .* sin(2*pi*fp*Tsignal);
passeBas = (2*fp/Fe)*sinc(2*(fp/Fe)*[-(N - 1)/2 : (N - 1)/2]);
x1filtre = filter(passeBas,1,x1);
x2filtre = filter(passeBas,1,x2);


xeRecu = x1filtre - 1j*x2filtre;

%Filtrage de reception-------------------------(1)
a = 0.35;
hr = rcosdesign(a, span, Ns);
z = filter(hr,1,xeRecu);
z = z(retardTotal+1:end);

%Tracé signal recu en fonction du temps
figure;
plot(Tsignal(retardTotal+1:end), real(z));
title('signal recu en fonction du temps');
xlabel('t en s');
ylabel('z(t)');


%Tracé du diagramme de l oeil en sortie du filtre de réception
figure;
plot(reshape(real(z),Ns,length(z)/Ns));
title('diagramme de l oeil en sortie du filtre de réception');
xlabel('');
ylabel('');

%Echantillonnage du signal reçu
zm = z(1:Ns:end);
aKRecu = real(zm) > 0;
bKRecu = imag(zm) > 0;

sigBinRecu = zeros(1,length(aKRecu) + length(bKRecu));
sigBinRecu(1:2:end) = aKRecu;
sigBinRecu(2:2:end) = bKRecu;

diff = sum(abs(sigBinRecu - Information));
TEB = diff/length(Information);

%Ajout Bruit
TEB = [];
SNRdBliste = [];
disp('Chaine de référence : ');
for i=0:7
    Px = mean(abs(x).^2);
    SNRdB = i;
    SNR = 10^(SNRdB/10);
    SNRdBliste = [SNRdBliste SNRdB];
    M = 2;
    sigma = sqrt((Px*Ns)/(2*log2(M)*SNR));
    bruit = sigma*randn(1, length(x));
    xBruite = x + bruit;
    
    %Retour en bande de base-----------------------(1)
    x1 = xBruite .* cos(2*pi*fp*Tsignal);
    x2 = xBruite .* sin(2*pi*fp*Tsignal);
    passeBas = (2*fp/Fe)*sinc(2*(fp/Fe)*[-(N - 1)/2 : (N - 1)/2]);
    x1filtre = filter(passeBas,1,x1);
    x2filtre = filter(passeBas,1,x2);
    
    xeRecu = x1filtre - 1j*x2filtre;
    
    %Filtrage de reception-------------------------(1)
    a = 0.35;
    hr = rcosdesign(a, span, Ns);
    z = filter(hr,1,xeRecu);
    z = z(retardTotal+1:end);

    %Echantillonnage du signal reçu
    zm = z(1:Ns:end);
    aKRecu = real(zm) > 0;
    bKRecu = imag(zm) > 0;
    sigBinRecu = zeros(1,length(aKRecu) + length(bKRecu));
    sigBinRecu(1:2:end) = aKRecu;
    sigBinRecu(2:2:end) = bKRecu;
    
    diff = sum(abs(sigBinRecu - Information));
    TEB = [TEB diff/length(Information)];
    disp(['TEB = ' num2str(100*diff/length(Information)) ' % pour un SNR = ' num2str(SNRdB) ' dB']);
end

%tracé TEB
semilogy(SNRdBliste, TEB);
title(['TEB en fonction du SNR en dB']);
xlabel('SNRdB');
ylabel('TEB');

%comparaison TEB avec TEB théorique
figure;
semilogy(SNRdBliste, TEB);
hold on;
semilogy(SNRdBliste, qfunc(sqrt(2.0*10.^(SNRdBliste/10)) * sin(pi/4)));
title(['comparaison TEB en fonction du SNR en dB avec théorique']);
legend('TEB','TEB théorique');
xlabel('SNRdB');
ylabel('TEB');
hold off;

TEB31 = TEB

%% Sauvegarde des variables nécessaires pour la suite
save('resultatsTAP31.mat', 'TEB31');
