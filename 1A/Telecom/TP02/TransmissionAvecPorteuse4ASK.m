close all;
clear;

%Information binaire a transmettre--------------(1)
NbBitsMessage = 10000;
Information = randi(2,1,NbBitsMessage) - 1;

%-------------------------------------------------------------------------------------------------------
%-----------------Implantation de la chaine passe-bas équivalente---------------------------------------
%-------------------------------------------------------------------------------------------------------

%Mapping :
ordreMod = 2;
aK = (2 * bi2de(reshape(Information, 2, length(Information)/2).') - 3).';
bK = 0;
dK = aK + 1j*bK;

figure;
plot(aK,bK, "X", Color='blue');
title('constellation');
xlabel('bk');
ylabel('ak');

%Surechantillonnage----------------------------(1)
Fe = 96000;
fp = 2000;
Te = 1/Fe;
L = length(dK);
Rb = 48000;
Ts = ordreMod/Rb;
Ns = floor(Ts/Te);

%retard anticipé
span = 10;
retardFMF = span*Ns/2;
retardFR = span*Ns/2;
retardTotal = retardFR + retardFMF;

Tsignal = [0 : Te : (L*Ns-1 + retardTotal)*Te];
signalAvantFiltre = [kron(dK, [1, zeros(1,Ns-1)]), zeros(1, retardTotal)];

%Filtrage de mise en forme---------------------(1)
a = 0.35;
h = rcosdesign(a, span, Ns);
xe = filter(h,1,signalAvantFiltre);

%Tracé signal en phase en fonction du temps
% figure;
% plot(Tsignal, real(xe));
% title('signal en phase en fonction du temps');
% xlabel('t en s');
% ylabel('RE[xe(t)]');

%Tracé signal en quadrature en fonction du temps
% figure;
% plot(Tsignal, imag(xe));
% title('signal en quadrature en fonction du temps');
% xlabel('t en s');
% ylabel('IM[xe(t)]');

%Tracé densité spectrale de puissance du signal transmis en fonction de la fréquence
Np = 4096;
DSP = pwelch(xe,[],[],Np,Fe,'centered');
% F = linspace(-Fe/2,Fe/2,Np);
% figure;
% semilogy(F,DSP);
% title('DSP  du signal modulé sur fréquence porteuse');
% xlabel('f en Hz');
% ylabel('DSPx(f)');


xeRecu = xe;

%Filtrage de reception-------------------------(1)
a = 0.35;
hr = rcosdesign(a, span, Ns);
z = filter(hr,1,xeRecu);
z = z(retardTotal+1:end);

%Tracé signal recu en fonction du temps
% figure;
% plot(Tsignal(retardTotal+1:end), real(z));
% title('signal recu en fonction du temps');
% xlabel('t en s');
% ylabel('z(t)');


%Tracé du diagramme de l oeil en sortie du filtre de réception
% figure;
% plot(reshape(real(z),Ns,length(z)/Ns));
% title('diagramme de l oeil en sortie du filtre de réception');
% xlabel('');
% ylabel('');

%Echantillonnage du signal reçu
ordreMod = 4;
zm = z(1:Ns:end);
aKRecu = real(zm) > 0;
bKRecu = imag(zm) > 0;

int = real(zm);
int2 = int;
int2(int < -2.5) = 0;
int2(-2.5 <= int & int < 0) = 1;
int2(0 <= int & int < 2.5) = 2;
int2(2.5 <= int) = 3;
sigBinRecu = reshape(de2bi(int2).', 1, length(Information));

figure;
plot(zm,0, "X", Color='blue');
title('constellation');
xlabel('bk');
ylabel('ak');

diff = sum(abs(sigBinRecu - Information));
TEBSansBruit = diff/length(Information);

%Ajout Bruit
TEB = [];
SNRdBliste = [];
disp('Chaine de référence : ');
for i=0:7
    Px = mean(abs(xe).^2);
    SNRdB = i;
    SNR = 10^(SNRdB/10);
    SNRdBliste = [SNRdBliste SNRdB];
    M = 2;
    sigma = sqrt((Px*Ns)/(2*log2(M)*SNR));
    bruit = sigma*randn(1, length(xe)) + 1j*sigma*randn(1, length(xe));
    
    xeRecu = xe + bruit;
    
    %Filtrage de reception-------------------------(1)
    a = 0.35;
    hr = rcosdesign(a, span, Ns);
    z = filter(hr,1,xeRecu);
    z = z(retardTotal+1:end);
    
    
    %Tracé du diagramme de l oeil en sortie du filtre de réception
%     figure;
%     plot(reshape(real(z),Ns,length(z)/Ns));
%     title(['diagramme de l oeil en sortie du filtre de réception pour un SNR = ' num2str(SNRdB) ' dB']);
%     xlabel('');
%     ylabel('');

    %Echantillonnage du signal reçu
    zm = z(1:Ns:end);
    aKRecu = real(zm) > 0;
    bKRecu = imag(zm) > 0;

    figure;
    plot(zm, "X");
    title('constellation');
    xlabel('bk');
    ylabel('ak');

    int = real(zm);
    int2 = int;
    int2(int < -2.5) = 0;
    int2(-2.5 <= int & int < 0) = 1;
    int2(0 <= int & int < 2.5) = 2;
    int2(2.5 <= int) = 3;
    sigBinRecu = reshape(de2bi(int2).', 1, length(Information));
    
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
semilogy(SNRdBliste, 2/ordreMod*(1-1/(2^ordreMod))*qfunc(sqrt(6.0*ordreMod/((2^ordreMod)^2-1)*ordreMod*10.^(SNRdBliste/10))));
title(['comparaison TEB en fonction du SNR en dB avec celui théorique']);
legend('TEB','TEB théorique');
xlabel('SNRdB');
ylabel('TEB');
hold off;

DSP4ASK = DSP;
TEB4ASK = TEB;
%% Sauvegarde des variables nécessaires pour la suite
save('resultats4ASK.mat', 'TEB4ASK', 'DSP4ASK');