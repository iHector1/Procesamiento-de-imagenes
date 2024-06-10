a = imread("imagen.png");
pesos = [0.2989,0.5870,0.1140];

apesos = a(:,:,1)*pesos(1)+a(:,:,2)*pesos(2)+a(:,:,3)*pesos(3);
figure(1);
imshow(apesos)

[m,n] = size(apesos);

for i =1 : m
    for j = 1 : n
        if apesos(i,j) <= 128
            apesos(i,j)=0;
        else
            apesos(i,j) = 255;
        end
    end

end
figure(2);
imshow(apesos);