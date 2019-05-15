# the-midway-histogram-equalization
Efficient single image non-uniformity correction algorithm
clc,close all,clear all;
% fp=importdata('noise180.txt');
% fp =uint8(fp./3);
% im = imread('01.png');
% im = im./2;
% ffp = fp+im;
% tu = ffp;
%设置矩阵大小
 tu= rgb2gray(imread('2.jpg'));
[h,w]=size(tu); 
new_tu = tu;
geshu = zeros(256,1);
ccgeshu = zeros(256,1);
geshupro = zeros(256,1);
geshuproo = zeros(256,w);
geshup = zeros(256,w);
newgeshu =zeros(256,w);
ccnewgeshu = zeros(256,w);
ccgeshup = zeros(256,w+1);
midgeshu = zeros(256,w+1);
midnewgeshu = zeros(256,w+1);
dpro = zeros(256,1);
new = zeros(256,w);
r = 5;
sigma =0.0016;
a= zeros();
b= zeros();
c= zeros();
d= zeros();
z= zeros();
ac = zeros();
cc = zeros(h,1);
cgeshu = zeros(256,1);
cgeshup = zeros(256,w+1);
%计算原始直方图各个灰度级像素个数geshu
for  y=1:w
     for x= 1:h
                geshu(tu(x,y)+1,1)= geshu(tu(x,y)+1,1)+1;
                for i =1 :256
                    geshup(i,y) = geshu(i,1);
                end    
     end
end

%中间矩阵midgehsu256*427
for i=1:256
    for j =1:w
       midgeshu(i,j+1) = geshup(i,j);
   end
end

%每列对应的像素个数的矩阵，即每列直方图,个数形式
for i = 1:w
      newgeshu(:,i) = midgeshu(:,i+1)- midgeshu(:,i);
end   
for i=1:256
    for j =1:w
       midnewgeshu(i,j+1) = newgeshu(i,j);
       midnewgeshu(:,1) = newgeshu(:,1);
    end
end

%相邻列中值化直方图，概率形式
for i = 1:w
     %中值化直方图
      a = midnewgeshu(:,i);
      b = midnewgeshu(:,i+1); 
      c = floor((a+b)/2 + 0.5);
       cpro= c./sum(c);
                for j= 2:256
                 cpro(j,1)=cpro(j,1)+cpro(j-1,1);  
                end
                 for j=1:256;
                  t(j,1)=floor(255*cpro(j,1)+0.5);
                 end
                 for x=1:h
                       ac(x,1)=t(tu(x,i)+1,1);
                 end 
                   for x=1:h
                       z(1,x)= ac(x,1);
                       z_filted = Gaussfilter(r, sigma, z);
                       z_filted = floor(z_filted);  
                       cc(x,1) = z_filted(1,x);
                   end
%                      for x = 1:h
%                        ccgeshu(cc(x,1)+1,1) = ccgeshu(cc(x,1)+1,1)+1;
%                      
%                          for j =1 :256
%                           ccgeshup(j,i+1) = ccgeshu(j,1);
%                          end 
%                      end
%                     for y = 1:w
%                        ccnewgeshu(:,y) = ccgeshup(:,y+1)- ccgeshup(:,y);
%                     end 
%                    dc = ccnewgeshu (:,i);
                 dc = imhist (cc);
                     
      a = dc;
      d = floor((a+b)/2 + 0.5);    
      %一个矩阵每列的概率密度
      dpro= d./sum(d);
      for j= 1:256
      oldpro(j,i) = dpro(j,1);
      end
      %计算每列累计概率
       for j= 2:256
            dpro(j,1)=dpro(j,1)+dpro(j-1,1);  
       end
       for j= 1:256
            ddpro(j,i) = dpro(j,1);
            %每列像素原图值对应的新值
            new(j,i) = floor(256*ddpro(j,i)+0.5);
       end

end

%新图的赋值
  for y =1:w
    for x=1:h
           new_tu(x,y) =  new(tu(x,y)+1,y);
    end  
  end

      
  figure(1),imshow(tu),title('噪声图');
  figure(2),imshow(new_tu),title('效果图');
