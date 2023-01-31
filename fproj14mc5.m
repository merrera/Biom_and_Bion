function BS2050ks = fproj14mc5 ( params ); % Projecao de cenarios Bioenergia
% Artigo Tomas_et_al 2
% GEANEX/UFPR
% Criado em 07/abr/2022
% Ultima revisao: 07/abr/2022
% Marcelo R. Errera, Ph.D. e NEST
% chamada pelo proj14mc5.m
% vide artigo - biocombustiveis 2030 2050 - abr de 2021.xlsx
%% VALIDADO COM A PLANILHA NO DIA 05/out/2021
%% Funcao que faz projecoes com contas corrigidas para eficiencia
%% Retorna o BE2050 para cada simulacao
%% Parametros variados no MC: BSG_CS, pEFLA, vr2, vr3 e Pop.
%clear all;
%
% tinicial = 2020;
% tfinal = 2050;
% periodo = [ tinicial tfinal ];
N_BS = 10; % numero de biofontes
N_S = 4; % numero de cenarios
BS2050ks = zeros (N_BS, N_S); % bioenergia [EJ] 2050
% inicio de variaveis
BS_CS = zeros (N_BS, 1); % EJ
%vr10 = [0.3, 0.3, 0.3, 3, 4, 3, 1, 5, 6, 3]'; %  em %
vr1 = zeros (N_BS, N_S); % biofontes e cenarios
vr2 = zeros (N_BS, N_S);
vr3 = zeros (N_BS, N_S);

%% dados de entrada

%% parametros variados no MC
if nargin < 1,
 BSG_CS = 55.6; % total de bionergia em 2018 / base para CS [EJ]
 pEFLA = 0.3; % arbitrado pelo cenario atual (fonte ??)
 % vr3 acima definido como zero
  FexpProd (1:6,1) = 0.;  
  FexpProd (1:6,2) = 0.2;  % aumento produtividade cult energ / CP
  FexpProd (1:6,3) = 0.5;  % aumento produtividade cult energ / CC
  FexpProd (1:6,4) = 0.65;  % * alterado de 200% para 65% aumento produtividade cult energ / Ci
  FexpProd (7:10,2:4) = 0.53;  % aumento produtividade energetica de residuos
  vr2 = FexpProd;
  %
  Pop = [ 7.7 10.1 9.7 9.4 ]'; % pop. mundo (habitantes) [bilhoes]
  %
  vr3 (1:2,1:4) = 0.;  % sem ganho de eficiencia de aproveitamento
  vr3 (3:10,1:2) = 0.; % sem ganho de eficiencia todos CS e BUS 
  vr3 (3,3) = 1.0; % ganho de eficiencia residuos florestais
  vr3 (3,4) = 2.5; % ganho de eficiencia residuos florestais
  %
  vr3 (4,3) = 7.5; % ganho de eficiencia agro residuos livestock
  vr3 (4,4) = 15.; % ganho de eficiencia agro residuos livestock ** ALTO **
  vr3 (5,3) = 0.25; % ganho de eficiencia residuos agric vegetais
  vr3 (5,4) = 0.50; % ganho de eficiencia residuos agric vegetais
  vr3 (6,3) = 0.;  % sem ganho de eficiencia energy crops (era zero)
  vr3 (6,4) = 0.;  % sem ganho de eficiencia energy crops (era zero)
  %
  vr3 (7,3) = 0.; % ganho de eficiencia black liquor
  vr3 (7,4) = 0.; % ganho de eficiencia black liquor
  %
  vr3 (8,3) = 0.5; % ganho de eficiencia residuos madeiras
  vr3 (8,4) = 1.0; % ganho de eficiencia residuos madeiras
  %
  vr3 (9,3) = 0.5; % ganho de eficiencia  madeira recuperada
  vr3 (9,4) = 1.0; % ganho de eficiencia  madeira recuperada
  %
  vr3 (10,3) = 7.5;  % ganho de eficiencia  MSW biogas
  vr3 (10,4) = 15.; % ganho de eficiencia  MSW biogas
else
    BSG_CS = params(1);
    pEFLA = params(2);
    FexpProd (1:6,1) = params(3);% 0.;  
    FexpProd (1:6,2) = params(4);% 0.2;  % aumento produtividade cult energ / CP
    FexpProd (1:6,3) = params(5);% 0.5;  % aumento produtividade cult energ / CC
    FexpProd (1:6,4) = params(6);% 0.65;  % * alterado de 200 % para 65% aumento produtividade cult energ / Ci
    FexpProd (7:10,2:4) = params(7);% 0.53;  % aumento produtividade residuos
    vr2 = FexpProd;
    Pop = [ params(8) params(9) params(10) params(11) ]'; 
    vr3 (3,3) = params (14); % expansao residuos florestais
    vr3 (3,4) = params (15); % expansao residuos florestais
    vr3 (4,3) = params (18); % expansao agro residuos livestock
    vr3 (4,4) = params (19); % expansao agro residuos livestock ** ALTO **
    vr3 (5,3) = params (22); % expansao residuos agric vegetais 
    vr3 (5,4) = params (23); % expansao residuos agric vegetais 
    %
    vr3 (8:9,3) = params (26); % expansao black liquor/wood resid/recov wood
    vr3 (8:9,4) = params (27); % expansao black liquor/wood resid/recov wood
    %
    vr3 (10,3) = vr3 (4,3);  % expansao  MSW biogas = livestock residues
    vr3 (10,4) = vr3 (4,4);  % expansao  MSW biogas = livestock residues
    
end; %if
%%

BS_CSf = [67, 7, 1, 3, 4, 3, 1, 5, 6, 3]'; %  em %
TFLA = [3900, 2965, 3900, 3900]'; % milhoes hectares da proj. areas cultv. JLUP
%pEFLA = 0.3; % arbitrado pelo cenario atual (fonte ??)
EFLA = pEFLA * TFLA; % proporcao de areas exploraveis
%
OfCal = [ 1.54  2.48  2.23 1.74; 
          9.03 12.57 11.35 8.55 ]; % [ EJ ]

%% Calculo do valor de correcao vr1
vr1 (:,1) = 1.0; % unitario para o CS

% para derivados de madeira florestas energeticas/industria / area exploravel 
for j = 1:3,
    for i = 1:N_S,
    vr1 (j,i) = EFLA(i)/EFLA(1); % [-]
    end; % j
end; % i

% para agricultura animais e vegetais
for j = 4:5,
    for i = 1:N_S,
    vr1 (j,i) = OfCal(j-3,i)/OfCal(j-3,1); % [-]
    end; % j
end; % i

% para culturas energeticas 
% ECLA = 13.8; % milhoes de hectares Tab. 4 Tomas 2 ALTERADO Eem 07/abr/22
ECLA = 8.8; 
vr1 (6,:) = [ 1  1 (588./ECLA) (3170./ECLA) ];
% residuos energeticos

% Pop = [ 7.7 10.1 9.7 9.4 ]'; % pop. mundo (habitantes) [bilhoes]
for j = 7:N_BS,
    for i = 1:N_S,
    vr1 (j,i) = Pop(i)/Pop(1); % [-]
    end; % j
end; % i		

%
%% Calculo do valor de correcao vr2
%  entrada na funcao

% FexpProd (1:6,1) = 0.;  
% FexpProd (1:6,2) = 0.2;  % aumento produtividade cult energ / CP
% FexpProd (1:6,3) = 0.5;  % aumento produtividade cult energ / CC
% FexpProd (1:6,4) = .65;  % * alterado de 200 % para 65% aumento produtividade cult energ / Ci
% FexpProd (7:10,2:4) = 0.53;  % aumento produtividade residuos
% %
% vr2 = FexpProd;
%
%% Calculo do valor de correcao vr3 (aproveitamento de residuos)
% see input / if 
%
%% preliminares
for i = 1:N_BS,
    BS_CS (i) = BSG_CS*BS_CSf(i)/100; % EJ   
end; % i

%% projecoes para 2050
for j = 1:N_BS,
    for i = 1:N_S,
     BS2050ks (j,i) = BS_CS (j) * vr1(j,i) * ( 1 + vr2(j,i) )* ( 1 + vr3 (j,i)) ; % projecoes Bioenergia 2050 [EJ]
    end; % j
end; % i

BE2050s = sum(BS2050ks);


%%