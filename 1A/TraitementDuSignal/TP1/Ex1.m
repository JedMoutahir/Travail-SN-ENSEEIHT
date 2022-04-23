f0 = 1100;
Fe = 10000;
N = 90;
A = 1;

T1 = [0 : 1/Fe : (N-1)/Fe];
F1 = [0 : Fe/N : (N-1)*Fe/N];

x1 = A*cos(2*pi*T1*f0);

figure;
plot(T1,x1);

title('Cosinus d amplitude 1 (V), de frequence f0 = 1100 Hz et echantillonne a Fe = 10000 Hz.');
xlabel('t en s');
ylabel('f(t)');

f0 = 1100;
Fe = 1000;
N = 90;
A = 1;

T2 = [0 : 1/Fe : (N-1)/Fe];
F2 = [0 : Fe/N : (N-1)*Fe/N];

x2 = A*cos(2*pi*T2*f0);

figure;
plot(T2,x2);

title('Cosinus d amplitude 1 (V), de frequence f0 = 1100 Hz et echantillonne a Fe = 1000 Hz.');
xlabel('t en s');
ylabel('f(t)');

X1 = abs(fft(x1));
X2 = abs(fft(x2));

figure;
plot(F1,X1);

title('Transformée de Fourier d un Cosinus d amplitude 1 (V), de frequence f0 = 1100 Hz et echantillonne a Fe = 10000 Hz.');
xlabel('f en Hz');
ylabel('F(f)');

figure;
plot(F2,X2);

title('Transformée de Fourier d un  Cosinus d amplitude 1 (V), de frequence f0 = 1100 Hz et echantillonne a Fe = 1000 Hz.');
xlabel('f en Hz');
ylabel('F(f)');

Fe = 10000;

M = 256;
X256 = abs(fft(x1, M));
F256 = [0 : Fe/M : (M-1)*Fe/M];

M = 512;
X512 = abs(fft(x1, M));
F512 = [0 : Fe/M : (M-1)*Fe/M];

M = 1024;
X1024 = abs(fft(x1, M));
F1024 = [0 : Fe/M : (M-1)*Fe/M];

M = 2048;
X2048 = abs(fft(x1, M));
F2048 = [0 : Fe/M : (M-1)*Fe/M];

figure;
semilogy(F256,X256);

title('Zero Padding 256 Transformée de Fourier d un  Cosinus d amplitude 1 (V), de frequence f0 = 1100 Hz et echantillonne a Fe = 1000 Hz.');
xlabel('f en Hz');
ylabel('F(f)');

figure;
semilogy(F512,X512);

title('Zero Padding 512 Transformée de Fourier d un  Cosinus d amplitude 1 (V), de frequence f0 = 1100 Hz et echantillonne a Fe = 1000 Hz.');
xlabel('f en Hz');
ylabel('F(f)');

figure;
semilogy(F1024,X1024);

title('Zero Padding 1024 Transformée de Fourier d un  Cosinus d amplitude 1 (V), de frequence f0 = 1100 Hz et echantillonne a Fe = 1000 Hz.');
xlabel('f en Hz');
ylabel('F(f)');

figure;
semilogy(F2048,X2048);

title('Zero Padding 2048 Transformée de Fourier d un  Cosinus d amplitude 1 (V), de frequence f0 = 1100 Hz et echantillonne a Fe = 1000 Hz.');
xlabel('f en Hz');
ylabel('F(f)');

Rx1 = xcorr(x1,x1,'biased');
FSx = [0 : Fe/(2*N) : (N-1)*Fe/N];

figure;
plot(FSx,abs((fft(Rx1))));

title('Corrélogramme d un  Cosinus d amplitude 1 (V), de frequence f0 = 1100 Hz et echantillonne a Fe = 1000 Hz.');
xlabel('f en Hz');
ylabel('F(f)');

Sx = 1/N * abs(fft(x1)).^2;

figure;
plot(F1,Sx);

title('Periodgramme d un  Cosinus d amplitude 1 (V), de frequence f0 = 1100 Hz et echantillonne a Fe = 1000 Hz.');
xlabel('f en Hz');
ylabel('F(f)');

Sx = pwelch(x1,[],[],[],Fe,'twosided');
FSx = [0 : Fe/length(Sx) : (length(Sx)-1)*Fe/length(Sx)];

figure;
plot(FSx,Sx);

title('Periodgramme de Welch d un  Cosinus d amplitude 1 (V), de frequence f0 = 1100 Hz et echantillonne a Fe = 1000 Hz.');
xlabel('f en Hz');
ylabel('F(f)');