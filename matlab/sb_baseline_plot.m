function []=plot_sb_baselines(ix)
%PLOT_SB_BASELINES plot the small baselines in small_baselines.list
%
%   Andy Hooper, June 2007
%
%   ======================================================================
%   09/2010 AH: Add option to plot in MERGED directory
%   09/2010 AH: For SMALL_BASELINES/MERGED don't plot dropped ifgs 
%   ======================================================================


if nargin <1
   ix=[];
end

currdir=pwd;
dirs=strread(currdir,'%s','delimiter','/');
if strcmp(dirs{end},'SMALL_BASELINES') 
    !\ls -d [1,2]* | sed 's/_/ /' > small_baselines.list
    load ../psver
    psname=['../ps',num2str(psver)];
    small_baseline_flag='y';
elseif strcmp(dirs{end},'MERGED') 
    cd ../SMALL_BASELINES
    !\ls -d [1,2]* | sed 's/_/ /' > ../MERGED/small_baselines.list
    cd ../MERGED
    load ../psver
    psname=['../ps',num2str(psver)];
    small_baseline_flag='y';
else
    load psver
    psname=['ps',num2str(psver)];
    small_baseline_flag='n';
end

sb=load('small_baselines.list');
n_ifg=size(sb,1);
if small_baseline_flag=='y' & isempty(ix) & exist('./parms.mat','file')
    drop_ifg_index=getparm('drop_ifg_index',1);
    if ~isempty(drop_ifg_index)
       ix=setdiff([1:n_ifg],drop_ifg_index);
    end
end

if ~isempty(ix)
    sb=sb(ix,:);
else 
    ix=1:size(sb,1);
end

ps=load(psname);

n_ifg=size(sb,1);
[yyyymmdd,I,J]=unique(sb);
ifg_ix=reshape(J,n_ifg,2);
x=ifg_ix(:,1);
y=ifg_ix(:,2);


day=str2num(datestr(ps.day,'yyyymmdd'));
[B,I]=intersect(day,yyyymmdd);

x=I(x);
y=I(y);

clf

for i=1:length(x)
    l=line([ps.day(x(i)),ps.day(y(i))],[ps.bperp(x(i)),ps.bperp(y(i))]);
    text((ps.day(x(i))+ps.day(y(i)))/2,(ps.bperp(x(i))+ps.bperp(y(i)))/2,num2str(ix(i)));
    set(l,'color',[0 1 0],'linewidth',2)
end
hold on
p=plot(ps.day,ps.bperp,'ro');
set(p,'markersize',12,'linewidth',2)
hold off
datetick('x',12)
ylabel('B_{perp}')

