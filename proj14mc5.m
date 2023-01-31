% Artigo Tomas_et_al 2
% Vr 3 rodando
% ENERGIA PRIMARIA DE BIOMASSA @ 2050
% GEANEX/UFPR
% Criado em 23/jan/2022
% Ultima revisao: 14/dec/2022
% Marcelo R. Errera, Ph.D./UFPR e NEST team
% vide artigo - biocombustiveis 2030 2050 - abr de 2021.xlsx
% funcoes:  bplot.m e fproj14mc5.m
% Chama a funcao que faz projecoes com contas corrigidas para eficiencia
% Parametros variados: BSG_CS, pEFLA, vr2, vr3 e Pop @2050
%% Retornando BS_2050 e BE_2050
%%
clear;
%%
gravar = 0;
%%
n_simul = 10001;
N_S = 4;
N_BS = 10; % numero de biofontes
error_margin = 0.4; % intervalo de variacao das grandezas em % +- 20%
BE2050smc = zeros (n_simul,N_S); % bioenergia por cenario [EJ] 2050 MC
BS2050ksmc = zeros (N_BS,N_S,n_simul); % bioenergia por biofonte e cenario [EJ] 2050
BS2050mean = zeros (N_BS,N_S); % bioenergia por cenario [EJ] 2050
soma = zeros (N_BS,N_S);
vr2_1a6 = zeros (n_simul, 4);
vr2_7a10 = zeros (n_simul, 4);
Pop = zeros (n_simul, 4);
%vr3_1a2 = zeros (n_simul, 4);
vr3_3 = zeros (n_simul, 4);
vr3_4 = zeros (n_simul, 4);
vr3_5 = zeros (n_simul, 4);
vr3_8a9 = zeros (n_simul, 4);
%vr3_10 = zeros (n_simul, 4);

%%   Generate n samples from a normal distribution
%     r = ( randn(n,1) * sd ) + mu
%     mu : mean
%     sd : standard deviation
% x1 ~ Normal distribution N(mean=100,sd=5)
% x1 = ( randn(n,1) * 5 ) + 100;
%% r = a + (b-a).*rand(N,1); uniform distribution
%%
%%%%%% parametros variaveis para MC
%%%
%% BSG_CS
mu = 55.6; % [ EJ]
faixa = error_margin *  mu;
sd = faixa/7;
BSG_CS = randn (n_simul,1)*sd + mu;

%  y_mean = mean(BSG_CS)
%  y_std = std(BSG_CS)
%  y_median = median(BSG_CS)

%% pEFLA 
mu = 0.3; % [ % ]
faixa = error_margin *  mu;
sd = faixa/7;
pEFLA = randn (n_simul,1)*sd + mu; % normal
%r = a + (b-a).*rand(N,1); uniform distribution
%pEFLA = (mu - faixa/2) + faixa*rand(n_simul,1); % uniforme

%%   vr2
mu = 0.001; % [%] CS 
faixa = 0.0003 *  mu;
sd = faixa/7;
vr2_1a6(:,1) = randn (n_simul,1)*sd + mu;
%
mu = 0.2; % [%] BUS @2050
faixa = error_margin *  mu;
sd = faixa/7;
vr2_1a6(:,2) = randn (n_simul,1)*sd + mu;
%vr2(:,2) = 0.20;
%
mu = 0.50; % [%] OPT @2050
faixa = error_margin *  mu;
sd = faixa/7;
vr2_1a6(:,3) = randn (n_simul,1)*sd + mu;
%vr2(:,2) = 0.50;
%
mu = 0.65; % [%] FAR @2050
faixa = error_margin *  mu;
sd = faixa/7;
vr2_1a6(:,4) = randn (n_simul,1)*sd + mu;
%
mu = 0.53; % [%] BUS, OPT and FAR @2050
faixa = error_margin *  mu;
sd = faixa/7;
vr2_7a10(:,2) = randn (n_simul,1)*sd + mu;
vr2_7a10(:,3) = vr2_7a10(:,2);
vr2_7a10(:,4) = vr2_7a10(:,2);
%
% Populacao @2050
Pop (:,1) = 7.7; % bilhoes
%
mu = 10.1; % [%] BUS @2050
faixa = error_margin/5 *  mu;
sd = faixa/7;
Pop (:,2) = randn (n_simul,1)*sd + mu;
%Pop(:,2) = 10.1;
%
mu = 9.7; % [%] OPT @2050
faixa = error_margin/5 *  mu;
sd = faixa/7;
Pop(:,3) = randn (n_simul,1)*sd + mu;
%Pop(:,3) = 9.7;
%
mu = 9.4; % [%] FAR @2050
faixa = error_margin/5 *  mu;
sd = faixa/7;
Pop(:,4) = randn (n_simul,1)*sd + mu;
%Pop(:,4) = 9.4;
%
%% vr3
%vr3_3 % forest residues
mu = 1.; % [%] OPT @2050
faixa = error_margin *  mu;
sd = faixa/7;
vr3_3 (:,3) = randn (n_simul,1)*sd + mu;
mu = 2.5; % [%] FAR @2050
faixa = error_margin *  mu;
sd = faixa/7;
vr3_3 (:,4) = randn (n_simul,1)*sd + mu;
%vr3_4 % agricultural wastes / livestock residues
mu = 7.5; % [%] OPT @2050
faixa = error_margin *  mu;
sd = faixa/7;
vr3_4 (:,3) = randn (n_simul,1)*sd + mu;
mu = 15.; % [%] FAR @2050
faixa = error_margin *  mu;
sd = faixa/7;
vr3_4 (:,4) = randn (n_simul,1)*sd + mu;
% vr3_5 % agricultural wastes / vegetable 
mu = 0.25; % [%] OPT @2050
faixa = error_margin *  mu;
sd = faixa/7;
vr3_5 (:,3) = randn (n_simul,1)*sd + mu;
mu = 0.5; % [%] FAR @2050
faixa = error_margin *  mu;
sd = faixa/7;
vr3_5 (:,4) = randn (n_simul,1)*sd + mu;
% vr3_8a9 wood industry residues & recovered woods
mu = 0.5; % [%] OPT @2050
faixa = error_margin *  mu;
sd = faixa/7;
vr3_8a9 (:,3) = randn (n_simul,1)*sd + mu;
mu = 1.0; % [%] FAR @2050
faixa = error_margin *  mu;
sd = faixa/7;
vr3_8a9 (:,4) = randn (n_simul,1)*sd + mu;

%% graficos dos parametros variaveis
figure(1); clf;

subplot (2,1,1);
hist (BSG_CS, 21);
title('BSG_C_S');
xlabel ('Bionergy [EJ]');
h = findobj(gca,'Type','patch');
h.FaceColor = 'blue';
h.EdgeColor = 'w';
%
subplot (2,1,2);
hist (pEFLA, 21);
title('pEFA');
xlabel ('Exploitation Share [%]');
h = findobj(gca,'Type','patch');
h.FaceColor = 'cyan';
h.EdgeColor = 'w';
%
figure(2); clf;

subplot (2,3,1);
hist (vr2_1a6(:,1), 21);
title('vr2 (1 to 6) - CS');
xlabel ('Productivity Gain [%]');
h = findobj(gca,'Type','patch');
h.FaceColor = 'blue';
h.EdgeColor = 'w';
%
subplot (2,3,2);
hist (vr2_1a6(:,2), 21);
title('vr2 (1 to 6) - BUS @2050');
xlabel ('Productivity Gain [%]');
h = findobj(gca,'Type','patch');
h.FaceColor = 'red';
h.EdgeColor = 'w';
%
subplot (2,3,4);
hist (vr2_1a6(:,3), 21);
title('vr2 (1 to 6) - OPT @2050');
xlabel ('Productivity Gain [%]');
h = findobj(gca,'Type','patch');
h.FaceColor = 'green';
h.EdgeColor = 'w';
%
subplot (2,3,5);
hist (vr2_1a6(:,4), 21);
title('vr2 (1 to 6) - FAR @2050');
xlabel ('Productivity Gain [%]');
h = findobj(gca,'Type','patch');
h.FaceColor = 'magenta';
h.EdgeColor = 'w';
%
subplot (2,3,6);
hist (vr2_7a10(:,2), 21);
title('vr2 (7 to 10) - BUS, OPT, FAR @2050');
xlabel ('Productivity Gain [%]');
h = findobj(gca,'Type','patch');
h.FaceColor = 'cyan';
h.EdgeColor = 'w';
%%
figure(3); clf;
subplot (1,3,1);
hist (Pop(:,2), 21);
title('Population @2050 - BUS');
xlabel ('Billions of inhabitants');
h = findobj(gca,'Type','patch');
h.FaceColor = 'red';
h.EdgeColor = 'w';
%
subplot (1,3,2);
hist (Pop(:,3), 21);
title('Population @2050 - OPT');
xlabel ('Billions of inhabitants');
h = findobj(gca,'Type','patch');
h.FaceColor = 'green';
h.EdgeColor = 'w';
%
subplot (1,3,3);
hist (Pop(:,4), 21);
title('Population @2050 - FAR');
xlabel ('Billions of inhabitants');
h = findobj(gca,'Type','patch');
h.FaceColor = 'magenta';
h.EdgeColor = 'w';
%% realiza projecoes de cada caso aleatorio do MC
% fazer em paralelo / video youtube
 for i = 1:n_simul,
    finput = [BSG_CS(i) pEFLA(i) vr2_1a6(i,1:4) vr2_7a10(i,2) Pop(i,:) vr3_3(i,:) vr3_4(i,:) vr3_5(i,:) vr3_8a9(i,:) ]; %27
    aBS2050ksmc(1:N_BS,1:N_S) = fproj14mc5 (finput);
    BS2050ksmc (:,:,i) = aBS2050ksmc;
    BE2050smc  (i,:) = sum(BS2050ksmc(:,:,i));
 end; %i
%%
figure(5); clf;
%
subplot (2,2,1);
hist (BE2050smc(:,1), 21);
title('CS');
xlabel ('Primary Bionergy [EJ]');
h = findobj(gca,'Type','patch');
h.FaceColor = [0 0.4470 0.7410];
h.EdgeColor = 'w';
%
subplot (2,2,2);
hist (BE2050smc(:,2), 21);
title('BUS @2050');
xlabel ('Primary Bionergy [EJ]');
h = findobj(gca,'Type','patch');
h.FaceColor = [0.6350 0.0780 0.1840];
h.EdgeColor = 'w';
%
subplot (2,2,3);
hist (BE2050smc(:,3), 21);
title('OPT @2050');
xlabel ('Primary Bionergy [EJ]');
h = findobj(gca,'Type','patch');
h.FaceColor = [0 0.5 0.5];
h.EdgeColor = 'w';
%
subplot (2,2,4);
hist (BE2050smc(:,4), 21);
title('FAR @2050');
xlabel ('Primary Bionergy [EJ]');
h = findobj(gca,'Type','patch');
h.FaceColor = [0.4940 0.1840 0.5560];
h.EdgeColor = 'w';

%
%% box plots
% figure(6); clf;
% %BE2050smc (:,4) = BE2050smc (:,4)/50;
% bplot (BE2050smc); % it requires to download this external function
% title('Primary Bionergy for CS, BUS, OPT and FAR @ 2050 [EJ]');
% ylabel ('Primary Bionergy [EJ]');


%% global sum of all biosources for each scenario
BE2050smed = mean(BE2050smc)
BE2050sstd = std(BE2050smc)
BE2050median = median(BE2050smc);

% media para BS2050
for i = 1:n_simul,
    for k = 1:N_BS,
        for s = 1:N_S,
            soma (k,s) = soma(k,s) + BS2050ksmc (k,s,i);
        end;
    end;
end;

BS2050mean = soma(:,:)/n_simul
%% Grava solucoes
if gravar,
    save ('proj14mc5.txt', 'BE2050smc', '-ascii');
    save ('proj14Pop.txt', 'Pop', '-ascii');
    save ('proj14vr21a6.txt', 'vr2_1a6', '-ascii');
    save ('proj14vr27a10.txt', 'vr2_7a10', '-ascii');
    save ('proj14vr3_3.txt', 'vr3_3', '-ascii');
    save ('proj14vr3_4.txt', 'vr3_4', '-ascii');
    save ('proj14vr3_5.txt', 'vr3_5', '-ascii');
    save ('proj14vr3_8a9.txt', 'vr3_8a9', '-ascii');
    save ('proj14pEFLA.txt', 'pEFLA', '-ascii');
    save ('proj14BSG_CS.txt', 'BSG_CS', '-ascii');
    save ('proj14BS2050mean.txt', 'BS2050mean', '-ascii');
end;

