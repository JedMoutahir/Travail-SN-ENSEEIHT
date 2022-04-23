f1 = 1000;
f2 = 3000;
Fe = 10000;
N = 100;

T = [0 : 1/Fe : (N-1)/Fe];
F = [0 : Fe/N : (N-1)*Fe/N];

x = cos(2*pi*T*f1) + cos(2*pi*T*f2);

figure;
plot(T,x);

title('Somme de deux cosinus d amplitude 1 (V), de frequences f1 = 1000 Hz et f2 = 3000 Hz et echantillonne a Fe = 10000 Hz.');
xlabel('t en s');
ylabel('f(t)');

X = abs(fft(x));

figure;
plot(F,X);

title('Transformée de Fourier d un Cosinus d amplitude 1 (V), de frequence f0 = 1100 Hz et echantillonne a Fe = 10000 Hz.');
xlabel('f en Hz');
ylabel('F(f)');

fc = (f1+f2)/2;
ordre = 11;
N0 = (ordre-1)/2;
%Tp = [0 : 1/Fe : N0/Fe];
Tp = [-N0/(2*Fe) : 1/Fe : (N0-1)/(2*Fe)];

a = 1;
b = sinc(2*fc*Tp);

%figure;
%plot(F,abs(fft(b)));

Tx = [-N/(2*Fe) : 1/Fe : (N-1)/(2*Fe)];
xfiltred11 = filter(b,a,x);

ordre = 61;
N0 = (ordre-1)/2;
%Tp = [0 : 1/Fe : N0/Fe];
Tp = [-N0/(2*Fe) : 1/Fe : (N0-1)/(2*Fe)];

a = 1;
b = sinc(2*fc*Tp);

%figure;
%plot(abs(fft(b,4096)));

xfiltred61 = filter(b,a,x);

figure;
plot(Tx,xfiltred11);

title('Signal filtré');
xlabel('t en s');
ylabel('f(t)');

Nf = 4096;
X1 = abs(fft(x,Nf));
freq = linspace(0,Fe,Nf);

figure;
plot(freq,X1);
hold on;
X2 = abs(fft(xfiltred11, Nf));
plot(freq,X2);
X3 = abs(fft(xfiltred61, Nf));
plot(freq,X3);
hold off;

title('Comparaison avant-après Filtrage en frequenciel.');
xlabel('f en Hz');
ylabel('F(f)');


figure;
plot(T,x);
hold on;
plot(T,xfiltred11);
plot(T,xfiltred61);
hold off;

title('Comparaison avant-après Filtrage en temporel.');
xlabel('t en s');
ylabel('f(t)');
