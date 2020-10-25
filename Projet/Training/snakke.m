clear all; 
close all; 
clc; 
%rect = getrect(gcf); 
%Img = I(rect(2):rect(2)+rect(4),rect(1):rect(1)+rect(3)); 
% imshowMy(IM) 
I=imread('image2.jpg'); 
%Im=double(I); 
Img=double(rgb2gray(I)); 
%Img=imresize(I,[80,80]); 
figure(1); imshow(uint8(Img)); 
[nx,ny]=size(Img); 
ic=floor(nx/2);         
jc=floor(ny/2); 
r=ic/3;                 
u = zeros([nx,ny]);      
for i=1:nx 
    for j=1:ny 
        u(i,j)= r-sqrt((i-ic).^2+(j-jc).^2); 
    end 
end 
figure(2);               
imshow(uint8(Img)); 
hold on; 
[c,h] = contour(u,[0 0],'r'); 
epsilon=1.0;            
nu=250;                  
delta_t=0.1; 
nn=0; 
for n=1:1000 
    H_u = 0.5*(1+(2/pi)*atan(u/epsilon)); 
    c1=sum(sum(H_u.*Img))/sum(sum(H_u)); 
    c2=sum(sum((1-H_u).*Img))/sum(sum(1-H_u)); 
    delta_H = (1/pi)*epsilon./(epsilon^2+u.^2); 
    m=delta_t*delta_H; 
    C_1 = 1./sqrt(eps+(u(:,[2:ny,ny])-u).^2+0.25*(u([2:nx,nx],:)-u([1,1:nx-1],:)).^2); 
    C_2 = 1./sqrt(eps+(u-u(:,[1,1:ny-1])).^2+0.25*(u([2:nx,nx],[1,1:ny-1])-u([1,1:nx-1],[1,1:ny-1])).^2); 
    C_3 = 1./sqrt(eps+(u([2:nx,nx],:)-u).^2+0.25*(u(:,[2:ny,ny])-u(:,[1,1:ny-1])).^2); 
    C_4 = 1./sqrt(eps+(u-u([1,1:nx-1],:)).^2+0.25*(u([1,1:nx-1],[2:ny,ny])-u([1,1:nx-1],[1,1:ny-1])).^2); 
    C = 1+nu*m.*(C_1+C_2+C_3+C_4); 
    u = (u+nu*m.*(C_1.*u(:,[2:ny,ny])+C_2.*u(:,[1,1:ny-1])+C_3.*u([2:nx,nx],:)+C_4.*u([1,1:nx-1],:) )+... 
        m.*((Img-c2).^2-(Img-c1).^2))./C; 
    if mod(n,200)==0     
        nn=nn+1 
        f=Img; 
        f(u>0)=c1; 
        f(u<0)=c2; 
        figure(2+nn); subplot(1,2,1);imshow(uint8(f)); 
        subplot(1,2,2); imshow(uint8(Img)); 
        hold on; 
        [c,h] = contour(u,[0 0],'r'); 
        hold off; 
    end 
end