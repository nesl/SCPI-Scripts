files =ls('run*'); 

#hold on;

energy = zeros(size(files,1)*2,1);
dtime = zeros(size(files,1)*2,1);

raw = [];

for i = 1:size(files,1)
  filename = strtrim(files(i,:));
  d = load(filename);
  idxa = find(d(:,3)<0); 
  d(idxa,3)=0;
  idxb = find(d(:,5)<0);  
  d(idxb,5)=0;
  #plot(d(:,1),d(:,3)); 
  #plot(d(:,1),d(:,5));
  energy(i*2-1) = trapz(d(:,1),d(:,3).*-d(:,2));
  energy(i*2) = trapz(d(:,1),d(:,5).*-d(:,4));
  dtime(i*2-1) = idxa(1)./4;
  dtime(i*2) = idxb(1)./4;

  nraw = size(raw)(1);
  nd = size(d)(1);
  if nd > nraw 
    raw(end+1:nd,:) = 0;
  end

  raw(1:nd,end+1) = d(:,1);
  raw(1:nd,end+1) = d(:,2);
  raw(1:nd,end+1) = d(:,3);
  raw(1:nd,end+1) = d(:,1);
  raw(1:nd,end+1) = d(:,4);
  raw(1:nd,end+1) = d(:,5);



end

#hold off;

raw = raw(:,2:end);


plot(raw(:,1),raw(:,3),"linewidth",4 ,raw(:,4),raw(:,6),"linewidth",4 ,raw(:,7),raw(:,9),"linewidth",4 ,raw(:,10),raw(:,12),"linewidth",4 ,raw(:,13),raw(:,15),"linewidth",4 ,raw(:,16),raw(:,18),"linewidth",4 ,raw(:,19),raw(:,21),"linewidth",4 ,raw(:,22),raw(:,24),"linewidth",4 ,raw(:,25),raw(:,27),"linewidth",4 ,raw(:,28),raw(:,30),"linewidth",4,raw(:,31),raw(:,33),"linewidth",4,raw(:,34),raw(:,36),"linewidth",4)
#plot(raw(:,1),raw(:,3).*-raw(:,2),"linewidth",4 ,raw(:,4),raw(:,6).*-raw(:,5),"linewidth",4 ,raw(:,7),raw(:,9).*-raw(:,8),"linewidth",4 ,raw(:,10),raw(:,12).*-raw(:,11),"linewidth",4 ,raw(:,13),raw(:,15).*-raw(:,14),"linewidth",4 ,raw(:,16),raw(:,18).*-raw(:,17),"linewidth",4 ,raw(:,19),raw(:,21).*-raw(:,20),"linewidth",4 ,raw(:,22),raw(:,24).*-raw(:,23))




axis([0,4500,0.001,1.2])
xlabel("Time (s)","fontsize",16)
ylabel("Voltage (V)","fontsize",16)
grid
set(gca,'fontsize',16);
print("discharge.eps","-color")

dlmwrite('raw.csv',raw);
csvwrite('results.csv',[1:length(dtime);dtime'; energy']);




