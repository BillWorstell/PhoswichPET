%MakePhoswichGeometryEvents
%
% Specify thickness pairs
%CZCThicknessSet=[5 10 15 20 25];
CZCThicknessSet=[25];
NCZC=numel(CZCThicknessSet);
BGOThicknessSet=[6 8 10 12 14];
%BGOThicknessSet=[14];
NBGO=numel(BGOThicknessSet);
%
%%%
%
% Specify material, timing, and cost parameters
CZCMaterial='CZC';
BGOMaterial='BGO';
CZCTimingCTRps3mm=[50.];
CZCTimingCTRps20mm=2.*CZCTimingCTRps3mm;
% Gundaker et al 2020 Phys Med Biol 65 025001
% "A best CTR of [158,277] FWHM for [3,20]mm long crystals"
BGOTimingCTRps3mm=158.;
BGOTimingCTRps20mm=277.;
CZCCostPerCC=15.;
BGOCostPerCC=35.;
%
%%%%%%%%%%
%
% Loop over thickness pairs
for iCZC=1:NCZC
  CZCThickness=CZCThicknessSet(iCZC);
  HalfCZC=0.5*CZCThickness;
  for iBGO=1:NBGO
    % Run Gate for this thickness pair
    BGOThickness=BGOThicknessSet(iBGO);
    % Check whether output already exists
    CZCBGOName=['CZC',num2str(CZCThickness),'_BGO',num2str(BGOThickness)];
    StatsFileName=['./Outputs/RunPhoswich_',CZCBGOName,'Stats.mat'];
    if (exist(StatsFileName))
      disp(['StatsFile found=',StatsFileName]);
    else
      disp(['Preparing to make ',StatsFileName]);
      HalfBGO=0.5*BGOThickness;
      %
      % Execute script to process GATE binaries
      source('main/ReadPhoswichGeometryNameHits.m');
      %
    end
   end
    %
endfor
%
disp('here');

