a = imread("image2.jpg");
pesos = [0.2989,0.5870,0.1140];
apesos = a(:,:,1)*pesos(1)+a(:,:,2)*pesos(2)+a(:,:,3)*pesos(3);
figure(1)
imshow(apesos)


[m,n] = size(apesos);
apesos = double(apesos);
Gx = zeros(size(apesos));
Gy = zeros(size(apesos));

%se aplica el filtro
for i = 2:m-1
    for j = 2:n-1
        Gx(i,j) = apesos(i-1,j-1) + 2*apesos(i,j-1) + apesos(i+1,j-1) - apesos(i-1,j+1) - 2*apesos(i,j+1) - apesos(i+1,j+1);
        Gy(i,j) = apesos(i-1,j-1) + 2*apesos(i-1,j) + apesos(i-1,j+1) - apesos(i+1,j-1) - 2*apesos(i+1,j) - apesos(i+1,j+1);
    end
end
figure(2)
imshow(Gx)
figure(3)
imshow(Gy)
Gt = sqrt(Gx.^2 + Gy.^2);
Vmax = max(max(Gt));

Gtn = (Gt/Vmax) * 255;
Gtn = uint8(Gtn);
%se binariza
B = Gtn > 100;

%obtendremos valores minimos de los gradientes
VminGx = min(min(Gx));
VminGy = min(min(Gy));
%utilizaremos los minimos desplaza para evitar negativos
GradoOffx = Gx - VminGx;
GradoOffy = Gy - VminGy;
%se obtienen valores maximos para gc y gy
VmaxGx = max(max(GradoOffx));
VmaxGy = max(max(GradoOffy));

%se normalizan los gradientes
GxN = (GradoOffx/VmaxGx) * 255;
GyN = (GradoOffy/VmaxGy) * 255;
GxN = uint8(GxN);
GyN = uint8(GyN);
%mostrar la imagen
figure(4)
imshow(GxN)
figure(5)
imshow(GyN)
figure(6)
imshow(Gtn)