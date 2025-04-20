InputFileName='./Outputs/RunPhoswich_CZC25_BGO10Hits.bin';
ThisFile=dir(InputFileName);
fid = fopen (InputFileName, "r");
NHits=ThisFile.bytes/136
NHits=100;
%
Hits.Run=zeros(NHits,1);
Hits.Event=zeros(NHits,1);
Hits.Crystal=zeros(NHits,1);
Hits.Layer=zeros(NHits,1);
Hits.Time=zeros(NHits,1);
Hits.Energy=zeros(NHits,1);
Hits.Range=zeros(NHits,1);
Hits.X=zeros(NHits,1);
Hits.Y=zeros(NHits,1);
Hits.Z=zeros(NHits,1);
Hits.HitType=zeros(NHits,24);
%
for iHit=1:NHits
  a = fread(fid,10,'int');
  Hits.Run(iHit)=a(1);
  Hits.Event(iHit)=a(2);
  Hits.Crystal(iHit)=a(9);
  Hits.Layer(iHit)=a(10);
  b = fread(fid,6,'double');
  Hits.Time(iHit)=b(1);
  Hits.Energy(iHit)=b(2);
  Hits.Range(iHit)=b(3);
  Hits.X(iHit)=b(4);
  Hits.Y(iHit)=b(5);
  Hits.Z(iHit)=b(6);
  c=fread(fid,6,'int');
  d=fread(fid,24,'char');
  Hits.HitType(iHit,:)=d';
end

fclose(fid);
%
[NEvents,iMax]=max(Event);
EventType=zeros(NEvents,1);
EventHits=zeros(NEvents,1);
First.Layer=zeros(NEvents,1);
First.T=zeros(NEvents,1);
First.Crystal=zeros(NEvents,1);
First.X=zeros(NEvents,1);
First.Y=zeros(NEvents,1);
First.Z=zeros(NEvents,1);
CZC.NHits=zeros(NEvents,1);
CZC.CrystalMean=zeros(NEvents,1);
CZC.CrystalSigma=zeros(NEvents,1);
CZC.Energy=zeros(NEvents,1);
CZC.TMean=zeros(NEvents,1);
CZC.TSigma=zeros(NEvents,1);
CZC.XMean=zeros(NEvents,1);
CZC.YMean=zeros(NEvents,1);
CZC.ZMean=zeros(NEvents,1);
CZC.XSigma=zeros(NEvents,1);
CZC.YSigma=zeros(NEvents,1);
CZC.ZSigma=zeros(NEvents,1);
BGO.NHits=zeros(NEvents,1);
BGO.CrystalMean=zeros(NEvents,1);
BGO.CrystalSigma=zeros(NEvents,1);
BGO.Energy=zeros(NEvents,1);
BGO.TMean=zeros(NEvents,1);
BGO.TSigma=zeros(NEvents,1);
BGO.XMean=zeros(NEvents,1);
BGO.YMean=zeros(NEvents,1);
BGO.ZMean=zeros(NEvents,1);
BGO.XSigma=zeros(NEvents,1);
BGO.YSigma=zeros(NEvents,1);
BGO.ZSigma=zeros(NEvents,1);
%
%%%%%%%%%%%%
%
% Collect statistics on all the hits in each event
for ThisEvent=1:NEvents;
  fHits=find(Hits.Event==(ThisEvent-1));
  if (numel(fHits)==0)
    % Sail-through event type
    EventType(ThisEvent)=9;
  else
    EventHits(ThisEvent)=numel(fHits);
    TheseHits=Hits(fHits);
    %
    FirstHit=min(fHits);
    First.Layer(ThisEvent)=Hits.Layer(FirstHit);
    First.T(ThisEvent)=Hits.Layer(FirstHit);
    First.Crystal(ThisEvent)=Hits.Crystal(FirstHit);
    First.X(ThisEvent)=Hits.X(FirstHit);
    First.Y(ThisEvent)=Hits.Y(FirstHit);
    First.Z(ThisEvent)=Hits.Z(FirstHit);
    %
    fCZC=find(TheseHits.Layer==0);
    if (numel(fCZC)>0)
      CZC.NHits(ThisEvent)=numel(fCZC);
      CZC.CrystalMean(ThisEvent)=mean(Hits.Crystal(fCZC));
      CZC.CrystalSigma(ThisEvent)=sigma(Hits.Crystal(fCZC));
      CZC.Energy(ThisEvent)=sum(Hits.Energy(fCZC));
      CZC.TMean(ThisEvent)=mean(Hits.Time(fCZC));
      CZC.TSigma(ThisEvent)=sigma(Hits.Time(fCZC));
      CZC.XMean(ThisEvent)=mean(Hits.X(fCZC));
      CZC.YMean(ThisEvent)=mean(Hits.Y(fCZC));
      CZC.ZMean(ThisEvent)=mean(Hits.Z(fCZC));
      CZC.XSigma(ThisEvent)=sigma(Hits.X(fCZC));
      CZC.YSigma(ThisEvent)=sigma(Hits.Y(fCZC));
      CZC.ZSigma(ThisEvent)=sigma(Hits.Z(fCZC));
    endif
   %
    fBGO=find(TheseHits.Layer==1);
    if (numel(fBGO)>0)
      BGO.NHits(ThisEvent)=numel(fBGO);
      BGO.CrystalMean(ThisEvent)=mean(Hits.Crystal(fBGO));
      BGO.CrystalSigma(ThisEvent)=sigma(Hits.Crystal(fBGO));
      BGO.Energy(ThisEvent)=sum(Hits.Energy(fBGO));
      BGO.TMean(ThisEvent)=mean(Hits.Time(fBGO));
      BGO.TSigma(ThisEvent)=sigma(Hits.Time(fBGO));
      BGO.XMean(ThisEvent)=mean(Hits.X(fBGO));
      BGO.YMean(ThisEvent)=mean(Hits.Y(fBGO));
      BGO.ZMean(ThisEvent)=mean(Hits.Z(fBGO));
      BGO.XSigma(ThisEvent)=sigma(Hits.X(fBGO));
      BGO.YSigma(ThisEvent)=sigma(Hits.Y(fBGO));
      BGO.ZSigma(ThisEvent)=sigma(Hits.Z(fBGO));
    endif
    % 
  endif
  %
  % CZC Hits but no BGO Hits
  fCZC_NoBGO = find((CZC.NHits>0)&(BGO.NHits==0));
  N_CZC_NoBGO = numel(fCZC_NoBGO);
  if (numel(fCZC_NoBGO)>0)
    fCZC_Escape=find(CZC.Energy(fCZC_NoBGO)<=0.5);
    NCZC_Escape=numel(fCZC_Escape);
    if (NCZC_Escape>0)
    % EventType 1: CZC Escape
      EventType(fCZC_NoBGO(fCZC_Escape))=1;
    endif
    %
    fCZC_Photopeak=find(CZC.Energy(fCZC_NoBGO)>0.5);
    NCZC_Photopeak=numel(fCZC_Photopeak);
    if (NCZC_Photopeak>0)
      % EventType 2: CZC Photopeak
      EventType(fCZC_NoBGO(fCZC_Escape))=2;
    endif
  end 
  %
  % BGO Hits but no CZC Hits
  fBGO_NoCZC = find((BGO.NHits>0)&(CZC.NHits==0));
  N_BGO_NoCZC = numel(fBGO_NoCZC);
  if (numel(fBGO_NoCZC)>0)
    fBGO_Escape=find(BGO.Energy(fBGO_NoCZC)<=0.5);
    NBGO_Escape=numel(fBGO_Escape);
    if (NBGO_Escape>0)
    % EventType 3: BGO Escape
      EventType(fBGO_NoCZC(fCZC_Escape))=3;
    endif
    %
    fBGO_Photopeak=find(BGO.Energy(fBGO_NoCZC)>0.5);
    NCZC_Photopeak=numel(fBGO_Photopeak);
    if (NCZC_Photopeak>0)
      % EventType 4: BGO Photopeak
      EventType(fCZC_NoBGO(fBGO_Photopeak))=4;
    endif
  end
  %
  % CZC Hits and BGO Hits
  fBGO_CZC = find((BGO.NHits>0)&(CZC.NHits>0));
  N_BGO_CZC = numel(fBGO_CZC);
  %
end
%
RunStatistics.NCZC_Escape=NCZC_Escape;
RunStatistics.NCZC_Photopeak=NCZC_Photopeak;
RunStatistics.NBGO_Escape=NBGO_Escape;
RunStatistics.NBGO_Photopeak=NBGO_Photopeak;
RunStatistics.NBoth=NBoth;
RunStatistics.NCZCFirst_Escape=NCZCFirst_Escape;
RunStatistics.NCZCFirst_Photopeak=NCZCFirst_Photopeak;
if (exist('NBGOFirst_Escape'))
  RunStatistics.NBGOFirst_Escape=NBGOFirst_Escape;
end
if (exist('NBGOFirst_Photopeak'))
  RunStatistics.NBGOFirst_Photopeak=NBGOFirst_Photopeak;
end
fSailThrough=find(EventType==9);
RunStatistics.NSailThrough=numel(fSailThrough);
RunStatistics.NPhotopeak=NCZC_Photopeak + NBGO_Photopeak+ ...
                NCZCFirst_Photopeak + NBGOFirst_Photopeak;
%
OutputFileName='./Outputs/RunPhoswich_CZC25_BGO10Hits.mat';
save -binary OutputFileName RunStatistics EventType First CZC BGO 
%