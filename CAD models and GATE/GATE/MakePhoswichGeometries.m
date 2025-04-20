%MakePhoswichGeometries
%
% Specify thickness pairs
%CZCThicknessSet=[15 20 25 30 35 40];
CZCThicknessSet=[5 10 15 20 25];
NCZC=numel(CZCThicknessSet);
BGOThicknessSet=[6 8 10 12 14];
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
OutputScript='RunGate.sh';
fid=fopen(OutputScript,'w');
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
    OutputFileName=['./Outputs/RunPhoswich_',CZCBGOName,'Hits.bin'];
    if (exist(OutputFileName))
      disp(['OutputFile found=',OutputFileName]);
    else
      disp(['Preparing to make ',OutputFileName]);
      HalfBGO=0.5*BGOThickness;
      Command=['Gate -a ', ...
    	'[CZCMaterial,',CZCMaterial,']', ...
    	'[BGOMaterial,',BGOMaterial,']', ...
    	'[CZCThickness,',num2str(CZCThickness),']', ...
    	'[BGOThickness,',num2str(BGOThickness),']', ...
    	'[HalfCZC,',num2str(HalfCZC),']', ...
    	'[HalfBGO,',num2str(HalfBGO),']', ...
    	'[RunTime,1] ./main/RunPhoswichGeometryHits.mac \n'];
      disp(Command);
      fprintf(fid,Command);
    end
   end
    %
endfor
%  
fclose(fid);

%if (isunix)
%  system('sudo chmod 774 RunGate.sh');
%end

% Process Gate OutputScript
%    CZCBGOName=['CZC',num2str(CZCThickness), ...
%    '_BGO',num2str(BGOThickness)];
%    ReadPhoswich_CZCBGONameHits;

