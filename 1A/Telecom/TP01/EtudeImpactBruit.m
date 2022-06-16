close all;
clear;

%Information binaire a transmettre
NbBitsMessage = 1000;
Infomation = randi(2,1,NbBitsMessage) -1;

%-------------------------------------------------------------
%-----------------Chaine de référence-------------------------
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

%Ajout Bruit
TEB = [];
SNRdBliste = [];
disp('Chaine de référence : ');
for i=0:8
    Px = mean(abs(signal1Filtred).^2);
    SNRdB = i;
    SNR = 10^(SNRdB/10);
    SNRdBliste = [SNRdBliste SNRdB];
    M = 2;
    sigma = sqrt((Px*Ns)/(2*log2(M)*SNR));
    bruit = sigma*randn(1, length(signal1Filtred));
    signalBruite = signal1Filtred + bruit;
    
    %Filtrage de réception : retangulaire
    rectangle = ones(1,Ns);
    signal1Reception= filter(rectangle,1,signalBruite);
    
    %Tracé du diagramme de l oeil en sortie du filtre de réception
    figure;
    plot(reshape(signal1Reception,Ns,length(signal1Reception)/Ns));
    title(['diagramme de l oeil en sortie du filtre de réception avec SNR = ' num2str(SNRdB) ' dB']);
    xlabel('');
    ylabel('');
    
    %Echantillonnage du signal reçu (bon)
    signalEch1 = signal1Reception(Ns:Ns:end);
    signalBinRecu1 = signalEch1 >=0;
    
    diff = sum(abs(Infomation - signalBinRecu1));
    TEB = [TEB diff/length(Infomation)];
    disp(['TEB = ' num2str(100*diff/length(Infomation)) ' % pour un SNR = ' num2str(SNRdB) ' dB']);
end

%comparaison TEB avec TEB théorique
figure;
semilogy(SNRdBliste, TEB);
hold on;
semilogy(SNRdBliste, qfunc(sqrt(2.0*10.^(SNRdBliste/10))));
title(['comparaison TEB en fonction du SNR en dB avec théorique']);
xlabel('SNRdB');
ylabel('TEB');
hold off;

%-------------------------------------------------------------
%---------------------Première chaine-------------------------
%-------------------------------------------------------------

disp('Premiere Chaine');
%Chaine sans bruit------------------------------------------------
disp('Chaine sans bruit : ');
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

%Filtrage de réception : front descendant
frontdescendant = [ones(1,Ns/2) zeros(1,Ns/2)];
signal1Reception= filter(frontdescendant,1,signal1Filtred);

%Tracé du diagramme de l oeil en sortie du filtre de réception
figure;
plot(reshape(signal1Reception,Ns,length(signal1Reception)/Ns));
title(['diagramme de l oeil en sortie du filtre de réception']);
xlabel('');
ylabel('');

%Echantillonnage du signal reçu (bon)
signalEch1 = signal1Reception(floor(3*Ns/4):Ns:end);
signalBinRecu1 = signalEch1 >=0;

diff = sum(abs(Infomation - signalBinRecu1));
TEB = diff/length(Infomation);
disp(['TEB = ' num2str(100*TEB) ' %']);

%Chaine avec bruit------------------------------------------------
disp('Chaine avec bruit : ');
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

%Ajout Bruit
TEB = [];
SNRdBliste = [];
for i=0:8
    Px = mean(abs(signal1Filtred).^2);
    SNRdB = i;
    SNR = 10^(SNRdB/10);
    SNRdBliste = [SNRdBliste SNRdB];
    M = 2;
    sigma = sqrt((Px*Ns)/(2*log2(M)*SNR));
    bruit = sigma*randn(1, length(signal1Filtred));
    signalBruite = signal1Filtred + bruit;
    
    %Filtrage de réception : front descendant
    frontdescendant = [ones(1,Ns/2) zeros(1,Ns/2)];
    signal1Reception= filter(frontdescendant,1,signalBruite);
    
    %Tracé du diagramme de l oeil en sortie du filtre de réception
    figure;
    plot(reshape(signal1Reception,Ns,length(signal1Reception)/Ns));
    title(['diagramme de l oeil en sortie du filtre de réception avec SNR = ' num2str(SNRdB) ' dB']);
    xlabel('');
    ylabel('');
    
    %Echantillonnage du signal reçu (bon)
    signalEch1 = signal1Reception(Ns:Ns:end);
    signalBinRecu1 = signalEch1 >=0;
    
    diff = sum(abs(Infomation - signalBinRecu1));
    TEB = [TEB diff/length(Infomation)];
    disp(['TEB = ' num2str(100*diff/length(Infomation)) ' % pour un SNR = ' num2str(SNRdB) ' dB']);
end

%comparaison TEB avec TEB théorique
figure;
semilogy(SNRdBliste, TEB);
hold on;
semilogy(SNRdBliste, qfunc(sqrt(10.^(SNRdBliste/10))));
title(['comparaison TEB en fonction du SNR en dB avec théorique']);
xlabel('SNRdB');
ylabel('TEB');
hold off;

%-------------------------------------------------------------
%---------------------Deuxième chaine-------------------------
%-------------------------------------------------------------

disp('Deuxième Chaine');

%Chaine sans bruit------------------------------------------------
disp('Chaine sans bruit : ');

%Mapping : binaire à moyenne nulle
mapped1 = (2 * bi2de(reshape(Infomation, 2, length(Infomation)/2).') - 3).';

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

%Tracé du diagramme de l oeil en sortie du filtre de réception
figure;
plot(reshape(signal1Reception,Ns,length(signal1Reception)/Ns));
title(['diagramme de l oeil en sortie du filtre de réception']);
xlabel('');
ylabel('');

%Echantillonnage du signal reçu (bon)
signalEch1 = signal1Reception(Ns:Ns:end);
signalBinRecu1 = reshape(de2bi((signalEch1 + 3*Ns)/(2*Ns)).', 1, length(Infomation));

diff = sum(abs(Infomation - signalBinRecu1));
TEB = diff/length(Infomation);
disp(['TEB = ' num2str(100*TEB) ' %']);

%Chaine avec bruit------------------------------------------------
disp('Chaine avec bruit : ');
%Mapping : binaire à moyenne nulle
mapped1 = (2 * bi2de(reshape(Infomation, 2, length(Infomation)/2).') - 3).';

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

%Ajout Bruit
TEB = [];
TES = [];
SNRdBliste = [];
for i=0:8
    Px = mean(abs(signal1Filtred).^2);
    SNRdB = i;
    SNR = 10^(SNRdB/10);
    SNRdBliste = [SNRdBliste SNRdB];
    M = 4;
    sigma = sqrt((Px*Ns)/(2*log2(M)*SNR));
    bruit = sigma*randn(1, length(signal1Filtred));
    signalBruite = signal1Filtred + bruit;
    
    %Filtrage de réception : rectangulaire
    rectangle = ones(1,Ns);
    signal1Reception= filter(rectangle,1,signalBruite);
    
    %Echantillonnage du signal reçu
    signalEch1 = signal1Reception(Ns:Ns:end);
    int = (signalEch1 + 3*Ns)/(2*Ns);
    int(int<0) = 0;
    int(0 <= int & int < 0.5) = 0;
    int(0.5 <= int & int < 1.5) = 1;
    int(1.5 <= int & int < 2.5) = 2;
    int(2.5 <= int) = 3;
    signalBinRecu1 = reshape(de2bi(int).', 1, length(Infomation));
    
    diff = sum(abs(Infomation - signalBinRecu1));
    TEB = [TEB diff/length(Infomation)];
    TES = [TES sum(abs(int - (mapped1+3)/2))/length(mapped1)];
    disp(['TEB = ' num2str(100*diff/length(Infomation)) ' % pour un SNR = ' num2str(SNRdB) ' dB']);
    disp(['TES = ' num2str(100*sum(abs(int - (mapped1+3)/2))/length(int)) ' % pour un SNR = ' num2str(SNRdB) ' dB']);
end

%tracé TES
figure;
semilogy(SNRdBliste, TES);
title(['TES en fonction du SNR en dB']);
xlabel('SNRdB');
ylabel('TES');

%comparaison TES avec TES théorique
figure;
semilogy(SNRdBliste, TES);
hold on;
semilogy(SNRdBliste, 3.0/2.0*qfunc(sqrt(4.0/5.0*10.^(SNRdBliste/10))));
title(['comparaison TES en fonction du SNR en dB avec théorique']);
xlabel('SNRdB');
ylabel('TES');
hold off;
figure;

%tracé TEB
semilogy(SNRdBliste, TEB);
title(['TEB en fonction du SNR en dB']);
xlabel('SNRdB');
ylabel('TEB');

%comparaison TEB avec TEB théorique
figure;
semilogy(SNRdBliste, TEB);
hold on;
semilogy(SNRdBliste, 3.0/4.0*qfunc(sqrt(4.0/5.0*10.^(SNRdBliste/10))));
title(['comparaison TEB en fonction du SNR en dB avec théorique']);
xlabel('SNRdB');
ylabel('TEB');
hold off;

