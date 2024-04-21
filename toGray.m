clc;
%Formula 1
obj = imread("imagen.png");
%figura original
figure(1);
imshow(obj);
[m,n,p] = size(obj);

for i=1 : m
    for j=1 : n
        x = obj(i,j)*0.299 + obj(i,j)*0.587 + obj(i,j)*0.114;
        obj(i,j,1) = x;
        obj(i,j,2) = x;
        obj(i,j,3) = x;
    end
end
%Por promedio
figure(2)
imshow(obj);


%Por pesos
a = imread("imagen.png");
pesos = [0.2989,0.5870,0.1140];

apesos = a(:,:,1)*pesos(1)+a(:,:,2)*pesos(2)+a(:,:,3)*pesos(3);
figure(3);
imshow(apesos)

%Binario
binario = apesos;
[m,n,p] = size(binario);
for i =1 : m
    for j = 1 : n
        if a(i,j) <= 128
            binario(i,j)=0;
        else
            binario(i,j) = 255;
        end
    end

end
figure(4);
imshow(binario);
