% ReadPhoswich_CZCBGONameHits.m (general case of GATE output binary)
%
if (!exist('CZCBGOName'))
  CZCBGOName='CZC25_BGO10';
end
%
% Reads a GATE output binary and generates MATLAB data files
InputFileName=['./Outputs/RunPhoswich_',CZCBGOName,'Hits.bin'];
OutputFileName=['./Outputs/RunPhoswich_',CZCBGOName,'Hits.mat'];
StatsFileName=['./Outputs/RunPhoswich_',CZCBGOName,'Stats.mat'];
SaveOutputFile=true;
ShowAndSavePlots=false;
%
  % Load Output file if StatsFile exists, generate both if it does not
if (exist(StatsFileName))
  load(StatsFileName);
else
  ThisFile=dir(InputFileName);
  fid = fopen (InputFileName, "r");
  % Get number of hits from file length
  NHits=ThisFile.bytes/136
  %
  % Initialize Hits Data Structure
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
  [NEvents,iMax]=max(Hits.Event);
  EventType=zeros(NEvents,1);
  EventNHits=zeros(NEvents,1);
  %
  % Initialize First Interaction data structure
  First.Layer=zeros(NEvents,1);
  First.T=zeros(NEvents,1);
  First.Crystal=zeros(NEvents,1);
  First.X=zeros(NEvents,1);
  First.Y=zeros(NEvents,1);
  First.Z=zeros(NEvents,1);
  % Initialize CZC Interactions data structure
  CZC.NHits=zeros(NEvents,1);
  CZC.CrystalMean=zeros(NEvents,1);
  CZC.CrystalStd=zeros(NEvents,1);
  CZC.Energy=zeros(NEvents,1);
  CZC.TMean=zeros(NEvents,1);
  CZC.TStd=zeros(NEvents,1);
  CZC.XMean=zeros(NEvents,1);
  CZC.YMean=zeros(NEvents,1);
  CZC.ZMean=zeros(NEvents,1);
  CZC.XStd=zeros(NEvents,1);
  CZC.YStd=zeros(NEvents,1);
  CZC.ZStd=zeros(NEvents,1);
  % Initialize BGO Interactions data structure
  BGO.NHits=zeros(NEvents,1);
  BGO.CrystalMean=zeros(NEvents,1);
  BGO.CrystalStd=zeros(NEvents,1);
  BGO.Energy=zeros(NEvents,1);
  BGO.TMean=zeros(NEvents,1);
  BGO.TStd=zeros(NEvents,1);
  BGO.XMean=zeros(NEvents,1);
  BGO.YMean=zeros(NEvents,1);
  BGO.ZMean=zeros(NEvents,1);
  BGO.XStd=zeros(NEvents,1);
  BGO.YStd=zeros(NEvents,1);
  BGO.ZStd=zeros(NEvents,1);
  %
  %%%%%%%%%%%%
  %
  % Collect statistics on all the hits in each event
  for ThisEvent=1:NEvents;
    if (mod(ThisEvent,1000)==0)
      disp(['ThisEvent=',num2str(ThisEvent)]);
    end
    fHits=find(Hits.Event==(ThisEvent-1));
    if (numel(fHits)==0)
      % Sail-through event type
      EventType(ThisEvent)=9;
    else
      EventNHits(ThisEvent)=numel(fHits);
      %    HitsFieldnames =
      %{
        [1,1] = Run
        [2,1] = Event
        [3,1] = Crystal
        [4,1] = Layer
        [5,1] = Time
        [6,1] = Energy
        [7,1] = Range
        [8,1] = X
        [9,1] = Y
        [10,1] = Z
        [11,1] = HitType
      %}
      % Fetch fields for Hits associated with this event (TheseHits)
      TheseHits.Run=Hits.Run(fHits);
      TheseHits.Event=Hits.Event(fHits);
      TheseHits.Crystal=Hits.Crystal(fHits);
      TheseHits.Layer=Hits.Layer(fHits);
      TheseHits.Run=Hits.Run(fHits);
      TheseHits.Time=Hits.Time(fHits);
      TheseHits.Energy=Hits.Energy(fHits);
      TheseHits.Range=Hits.Range(fHits);
      TheseHits.X=Hits.X(fHits);
      TheseHits.Y=Hits.Y(fHits);
      TheseHits.Z=Hits.Z(fHits);
      TheseHits.Run=Hits.Run(fHits);
      %
      % Calculate and store fields related to first hit for this event
      FirstHit=min(fHits);
      First.Layer(ThisEvent)=Hits.Layer(FirstHit);
      First.T(ThisEvent)=Hits.Layer(FirstHit);
      First.Crystal(ThisEvent)=Hits.Crystal(FirstHit);
      First.X(ThisEvent)=Hits.X(FirstHit);
      First.Y(ThisEvent)=Hits.Y(FirstHit);
      First.Z(ThisEvent)=Hits.Z(FirstHit);
      %
      % Calculate and store fields related to interactions in CZC
      fCZC=find(TheseHits.Layer==0);
      if (numel(fCZC)>0)
        CZC.NHits(ThisEvent)=numel(fCZC);
        CZC.CrystalMean(ThisEvent)=mean(TheseHits.Crystal(fCZC));
        CZC.CrystalStd(ThisEvent)=std(TheseHits.Crystal(fCZC));
        CZC.Energy(ThisEvent)=sum(TheseHits.Energy(fCZC));
        CZC.TMean(ThisEvent)=mean(TheseHits.Time(fCZC));
        CZC.TStd(ThisEvent)=std(TheseHits.Time(fCZC));
        CZC.XMean(ThisEvent)=mean(TheseHits.X(fCZC));
        CZC.YMean(ThisEvent)=mean(TheseHits.Y(fCZC));
        CZC.ZMean(ThisEvent)=mean(TheseHits.Z(fCZC));
        CZC.XStd(ThisEvent)=std(TheseHits.X(fCZC));
        CZC.YStd(ThisEvent)=std(TheseHits.Y(fCZC));
        CZC.ZStd(ThisEvent)=std(TheseHits.Z(fCZC));
      endif
      %
      % Calculate and store fields related to interactions in BGO
      fBGO=find(TheseHits.Layer==1);
      if (numel(fBGO)>0)
        BGO.NHits(ThisEvent)=numel(fBGO);
        BGO.CrystalMean(ThisEvent)=mean(TheseHits.Crystal(fBGO));
        BGO.CrystalStd(ThisEvent)=std(TheseHits.Crystal(fBGO));
        BGO.Energy(ThisEvent)=sum(TheseHits.Energy(fBGO));
        BGO.TMean(ThisEvent)=mean(TheseHits.Time(fBGO));
        BGO.TStd(ThisEvent)=std(TheseHits.Time(fBGO));
        BGO.XMean(ThisEvent)=mean(TheseHits.X(fBGO));
        BGO.YMean(ThisEvent)=mean(TheseHits.Y(fBGO));
        BGO.ZMean(ThisEvent)=mean(TheseHits.Z(fBGO));
        BGO.XStd(ThisEvent)=std(TheseHits.X(fBGO));
        BGO.YStd(ThisEvent)=std(TheseHits.Y(fBGO));
        BGO.ZStd(ThisEvent)=std(TheseHits.Z(fBGO));
      endif
      % 
    endif
  end 
  %
  %%%
  %
  % Classify events by type
  %
  %%%
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
      EventType(fCZC_NoBGO(fCZC_Photopeak))=2;
    endif
    %
    % BGO Hits but no CZC Hits
    fBGO_NoCZC = find((BGO.NHits>0)&(CZC.NHits==0));
    N_BGO_NoCZC = numel(fBGO_NoCZC);
    if (N_BGO_NoCZC>0)
      fBGO_Escape=find(BGO.Energy(fBGO_NoCZC)<=0.5);
      NBGO_Escape=numel(fBGO_Escape);
      if (NBGO_Escape>0)
      % EventType 3: BGO Escape
        EventType(fBGO_NoCZC(fBGO_Escape))=3;
      endif
      %
      fBGO_Photopeak=find(BGO.Energy(fBGO_NoCZC)>0.5);
      NBGO_Photopeak=numel(fBGO_Photopeak);
      if (NBGO_Photopeak>0)
        % EventType 4: BGO Photopeak
        EventType(fBGO_NoCZC(fBGO_Photopeak))=4;
      endif
    end
    %
    % CZC Hits and BGO Hits
    fBoth = find((BGO.NHits>0)&(CZC.NHits>0));
    NBoth = numel(fBoth);
    if (NBoth>0)
      % First.Layer(ThisEvent)=Hits.Layer(FirstHit);
      fCZCFirst=find(First.Layer(fBoth)==0);
      NCZCFirst=numel(fCZCFirst);
      if (NCZCFirst>0)
        BothEnergy=CZC.Energy(fBoth(fCZCFirst))+BGO.Energy(fBoth(fCZCFirst));
        fCZCFirst_Escape=find(BothEnergy<=0.5);
        NCZCFirst_Escape=numel(fCZCFirst_Escape);
        if (NCZCFirst_Escape>0)
          % EventType 5: CZC Compton Escape
          EventType(fBoth(fCZCFirst_Escape))=5;
        endif
        fCZCFirst_Photopeak=find(BothEnergy>0.5);
        NCZCFirst_Photopeak=numel(fCZCFirst_Photopeak);
        if (NCZCFirst_Photopeak>0)
          % EventType 6: CZC Compton Photopeak
          EventType(fBoth(fCZCFirst_Photopeak))=6;
        endif
      end
      %
      fBGOFirst=find(First.Layer(fBoth)==1);
      NBGOFirst=numel(fBGOFirst);
      if (NBGOFirst>0)
        BothEnergy=CZC.Energy(fBoth(fBGOFirst))+BGO.Energy(fBoth(fBGOFirst));
        fBGOFirst_Escape=find(BothEnergy<=0.5);
        NBGOFirst_Escape=numel(fBGOFirst_Escape);
        if (NBGOFirst_Escape>0)
          % EventType 7: BGO Compton Escape
          EventType(fBoth(fBGOFirst_Escape))=7;
        endif
        fBGOFirst_Photopeak=find(BothEnergy>0.5);
        NBGOFirst_Photopeak=numel(fBGOFirst_Photopeak);
        if (NBGOFirst_Photopeak>0)
          % EventType 8: BGO Compton Photopeak
          EventType(fBoth(fBGOFirst_Photopeak))=8;
        endif
      end
      %
    end
  end
  % Store Run Statistics
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
  if (SaveOutputFile)
    Command=['save ',OutputFileName,' First CZC BGO'];
    disp(Command);
    eval(Command);
  end 
  %
  %%%%%%%%
  % Generate Statistics for each Event Type
  %
  %%%
  % CZC and BGO have the same fields in their structures
    %fieldnames(CZC) 
  %ans =
  %{
    [1,1] = NHits
    [2,1] = CrystalMean
    [3,1] = CrystalStd
    [4,1] = Energy
    [5,1] = TMean
    [6,1] = TStd
    [7,1] = XMean
    [8,1] = YMean
    [9,1] = ZMean
    [10,1] = XStd
    [11,1] = YStd
    [12,1] = ZStd 
  %}
  %
  %%%
  %
  % EventType 1: CZC Escape
  fCZC_Escape=find(EventType==1);
  NCZC_Escape=numel(fCZC_Escape);
  if (NCZC_Escape>0)
%    fieldnames(CZC_Escape)
%ans =
%{
%  [1,1] = NHits
%  [2,1] = Energy
%}
    CZC_Escape.NHits=hist(CZC.NHits(fCZC_Escape),1:1:5); 
    if (ShowAndSavePlots)
      figure(11);
      hist(CZC.NHits(fCZC_Escape),1:1:5)
      xlabel('NHits');ylabel('Events');title('CZC Escapes');
      saveas(11,'./Outputs/',CZCBGOName,'CZC_Escape_NHits.png');
    endif
    CZC_Escape.Energy=hist(CZC.Energy(fCZC_Escape),0:0.01:0.5);
    if (ShowAndSavePlots)
      figure(12);
      hist(CZC.Energy(fCZC_Escape),[0:0.01:0.5]);
      xlabel('Energy MeV');ylabel('Events');title('CZC Escapes');
      xlim([0.,0.5]);
      saveas(12,'./Outputs/',CZCBGOName,'CZC_Escape_Energy.png');
     end
  endif
  %
  %%%
  %
  % EventType 2: CZC Photopeak
  fCZC_Photopeak=find(EventType==2);
  NCZC_Photopeak=numel(fCZC_Photopeak);
  if (NCZC_Photopeak>0)
%     fieldnames(CZC_Photopeak)
%ans =
%{
%  [1,1] = NHits
%  [2,1] = XMean
%  [3,1] = YMean
%  [4,1] = ZMean
%  [5,1] = XStd
%  [6,1] = ZStd
%  [7,1] = YStd
%}
    CZC_Photopeak.NHits=hist(CZC.NHits(fCZC_Photopeak),1:1:5); 
    if (ShowAndSavePlots)
      figure(21);
      hist(CZC.NHits(fCZC_Photopeak),1:1:5);
      xlabel('NHits');ylabel('Events');title('CZC Photopeak');
      saveas(21,'./Outputs/',CZCBGOName,'CZC_Photopeak_NHits.png');
    endif
    CZC_Photopeak.XMean=hist(CZC.XMean(fCZC_Photopeak),-10:1:10); 
    if (ShowAndSavePlots)
      figure(22);
      hist(CZC.XMean(fCZC_Photopeak),-10:1:10)
      xlabel('mm');ylabel('Events');title('CZC XMean');
      saveas(22,'./Outputs/',CZCBGOName,'',_CZC_Photopeak_XMean.png');
    end
    CZC_Photopeak.YMean=hist(CZC.YMean(fCZC_Photopeak),-25:1:25); 
    if (ShowAndSavePlots)
      figure(23);
      hist(CZC.YMean(fCZC_Photopeak),-25:1:25)
      xlabel('mm');ylabel('Events');title('CZC YMean');
      saveas(23,'./Outputs/',CZCBGOName,'',_CZC_Photopeak_YMean.png');
    end
    CZC_Photopeak.ZMean=hist(CZC.ZMean(fCZC_Photopeak),-10:1:10); 
    if (ShowAndSavePlots)
      figure(24);
      hist(CZC.ZMean(fCZC_Photopeak),-10:1:10)
      xlabel('mm');ylabel('Events');title('CZC ZMean');
      saveas(24,'./Outputs/',CZCBGOName,'',_CZC_Photopeak_ZMean.png');
    end
    CZC_Photopeak.XStd=hist(CZC.XStd(fCZC_Photopeak),0:1:20); 
    if (ShowAndSavePlots)
      figure(25);
      hist(CZC.XStd(fCZC_Photopeak),0:1.:20)
      xlabel('mm');ylabel('Events');title('CZC XStd');
      saveas(25,'./Outputs/',CZCBGOName,'',_CZC_Photopeak_XStd.png');
    end
    CZC_Photopeak.YStd=hist(CZC.YStd(fCZC_Photopeak),0:1:50); 
    if (ShowAndSavePlots)
      figure(26);
      hist(CZC.YStd(fCZC_Photopeak),0.:1.:20)
      xlabel('mm');ylabel('Events');title('CZC Std');
      saveas(26,'./Outputs/',CZCBGOName,'',_CZC_Photopeak_Std.png');
    end
    CZC_Photopeak.ZStd=hist(CZC.ZStd(fCZC_Photopeak),0:1:50); 
    if (ShowAndSavePlots)
      figure(27);
      hist(CZC.ZStd(fCZC_Photopeak),0:1.:20)
      xlabel('mm');ylabel('Events');title('CZC ZStd');
      saveas(27,'./Outputs/',CZCBGOName,'',_CZC_Photopeak_ZStd.png');
    end
  endif
  %
  %%%
  %
  %%%
  %
  % EventType 3: BGO Escape
  fBGO_Escape=find(EventType==3);
  NBGO_Escape=numel(fBGO_Escape);
  if (NBGO_Escape>0)
%    fieldnames(BGO_Escape)
%ans =
%{
%  [1,1] = NHits
%  [2,1] = Energy
%}
    BGO_Escape.NHits=hist(BGO.NHits(fBGO_Escape),1:1:5); 
    if (ShowAndSavePlots)
      figure(31);
      hist(BGO.NHits(fBGO_Escape),1:1:5)
      xlabel('NHits');ylabel('Events');title('BGO Escapes');
      saveas(31,'./Outputs/BGO25_BGO10_BGO_Escape_NHits.png');
    endif
    BGO_Escape.Energy=hist(BGO.Energy(fBGO_Escape),0:0.01:0.5);
    if (ShowAndSavePlots)
      figure(32);
      hist(BGO.Energy(fBGO_Escape),[0:0.01:0.5]);
      xlabel('Energy MeV');ylabel('Events');title('BGO Escapes');
      xlim([0.,0.5]);
      saveas(32,'./Outputs/BGO25_BGO10_BGO_Escape_Energy.png');
     end
  endif
  %
  %%%
  %
  % EventType 4: BGO Photopeak
  fBGO_Photopeak=find(EventType==4);
  NBGO_Photopeak=numel(fBGO_Photopeak);
  if (NBGO_Photopeak>0)
%     fieldnames(BGO_Photopeak)
%ans =
%{
%  [1,1] = NHits
%  [2,1] = XMean
%  [3,1] = YMean
%  [4,1] = ZMean
%  [5,1] = XStd
%  [6,1] = ZStd
%  [7,1] = YStd
%}
    BGO_Photopeak.NHits=hist(BGO.NHits(fBGO_Photopeak),1:1:5); 
    if (ShowAndSavePlots)
      figure(41);
      hist(BGO.NHits(fBGO_Photopeak),1:1:5);
      xlabel('NHits');ylabel('Events');title('BGO Photopeak');
      saveas(41,'./Outputs/',CZCBGOName,'',_BGO_Photopeak_NHits.png');
    endif
    BGO_Photopeak.XMean=hist(BGO.XMean(fBGO_Photopeak),-10:1:10); 
    if (ShowAndSavePlots)
      figure(42);
      hist(BGO.XMean(fBGO_Photopeak),-10:1:10)
      xlabel('mm');ylabel('Events');title('BGO XMean');
      saveas(42,'./Outputs/',CZCBGOName,'',_BGO_Photopeak_XMean.png');
    end
    BGO_Photopeak.YMean=hist(BGO.YMean(fBGO_Photopeak),-25:1:25); 
    if (ShowAndSavePlots)
      figure(43);
      hist(BGO.YMean(fBGO_Photopeak),-25:1:25)
      xlabel('mm');ylabel('Events');title('BGO YMean');
      saveas(43,'./Outputs/',CZCBGOName,'',_BGO_Photopeak_YMean.png');
    end
    BGO_Photopeak.ZMean=hist(BGO.ZMean(fBGO_Photopeak),-10:1:10); 
    if (ShowAndSavePlots)
      figure(44);
      hist(BGO.ZMean(fBGO_Photopeak),-10:1:10)
      xlabel('mm');ylabel('Events');title('BGO_Photopeak ZMean');
      saveas(44,'./Outputs/',CZCBGOName,'',_BGO_Photopeak_ZMean.png');
    end
    BGO_Photopeak.XStd=hist(BGO.XStd(fBGO_Photopeak),0:1:20); 
    if (ShowAndSavePlots)
      figure(45);
      hist(BGO.XStd(fBGO_Photopeak),0:1.:20)
      xlabel('mm');ylabel('Events');title('BGO_Photopeak XStd');
      saveas(45,'./Outputs/',CZCBGOName,'',_BGO_Photopeak_XStd.png');
    end
    BGO_Photopeak.YStd=hist(BGO.YStd(fBGO_Photopeak),0:1:50); 
    if (ShowAndSavePlots)
      figure(46);
      hist(BGO.YStd(fBGO_Photopeak),0.:1.:20)
      xlabel('mm');ylabel('Events');title('BGO_Photopeak YStd');
      saveas(46,'./Outputs/',CZCBGOName,'',_BGO_Photopeak_YStd.png');
    end
    BGO_Photopeak.ZStd=hist(BGO.ZStd(fBGO_Photopeak),0:1:50); 
    if (ShowAndSavePlots)
      figure(47);
      hist(BGO.ZStd(fBGO_Photopeak),0:1.:20)
      xlabel('mm');ylabel('Events');title('BGO_Photopeak ZStd');
      saveas(47,'./Outputs/CZCO25_BGO10_BGO_Photopeak_ZStd.png');
    end
  endif
  %
  %%%
  %
  Command=['save ',StatsFileName,...
    ' RunStatistics EventType EventNHits', ...
    ' CZC_Escape CZC_Photopeak BGO_Escape BGO_Photopeak'];
  disp(Command);
  eval(Command); 
  %
end
%
RunStatistics
%

