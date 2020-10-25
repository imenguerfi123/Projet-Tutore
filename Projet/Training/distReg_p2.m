function f = distReg_p2(phi)
[phi_x,phi_y]=gradient(phi);
s=sqrt(phi_x.^2 + phi_y.^2);
a=(s>=0) & (s<=1);
b=(s>1);
ps=a.*sin(2*pi*s)/(2*pi)+b.*(s-1);
dps=((ps~=0).*ps+(ps==0))./((s~=0).*s+(s==0));
f = div(dps.*phi_x - phi_x, dps.*phi_y - phi_y) + 4*del2(phi);