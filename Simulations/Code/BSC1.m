function f=BSC(x,p)
index=find(rand(size(x))<p);
y=x;
y(index)=~x(index);
f=y;