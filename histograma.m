a = imread("https://images.pexels.com/photos/1547813/pexels-photo-1547813.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2");
figure(1);
imshow(a);
pesos = [0.2989,0.5870,0.1140];
grises = a(:,:,1)*pesos(1)+a(:,:,2)*pesos(2)+a(:,:,3)*pesos(3);

figure(2);
imshow(grises);

% %contraste
% prox = grises * 1.5;
% 
% figure(3);
% imshow(prox);
% %brillo
% prox2 = (grises * 1.5)+100;
% 
% figure(4);
% imshow(prox2);
% 
[fil,col] = size(grises);
pixmax = 256;
tam = zeros(pixmax);
%histograma

for rxp = 1:fil
    for ryp = 1:col
        rxyp = grises(rxp,ryp);
        for val = 1:pixmax
            if rxyp == val
                tam(val) = tam(val)+1;
            end
        end
    end
end
figure(3)
stem(tam);
figure(4)
imshow(tam)
%acumulativo
H = [1:256];
Vo=0;

for ru = 1:256
    H(ru) = Vo+tam(ru);
    Vo = H(ru);
end

figure(6);
stem(H);
figure(7);
imshow(H);
val =256;
%ecualizado
Inh = [1:256];
disp(val);
for rxs = 1:fil
    for rys =1 :col
        ac = grises(rxs,rys);
        if ac ==val
            Inh(rxs,rys) = tam(ac+1)*255/(fil*col);
        end
    end
end

figure(8)
stem(Inh);
figure(9)
imshow(Inh)

