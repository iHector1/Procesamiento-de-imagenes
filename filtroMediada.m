a = imread("imagen.png");
pesos = [0.2989,0.5870,0.1140];
apesos = a(:,:,1)*pesos(1)+a(:,:,2)*pesos(2)+a(:,:,3)*pesos(3);
figure(1)
imshow(apesos)
imageNoise = imnoise(apesos,'salt & pepper',0.05);
figure(2)
imshow(imageNoise);
filtro = filtro_mediana(imageNoise);
figure(3);
imshow(filtro);
%filtro de la mediana%

function imagen_filtrada = filtro_mediana(imagen)
    imagen_filtrada = imagen;
    [filas,columnas] = size(imagen);
    for i=2:filas-1
        for j=2:columnas-1
            % Obtener los valores de intensidad de la ventana en un array
            ventana = [imagen(i-1, j-1), imagen(i-1, j), imagen(i-1, j+1); 
                       imagen(i, j-1), imagen(i, j), imagen(i, j+1); 
                       imagen(i+1, j-1), imagen(i+1, j), imagen(i+1, j+1)];
    
            % Convertir la ventana en un array unidimensional
            ventana = ventana(:);

            % Ordenar los valores de intensidad en la ventana
            ventana_ordenada = sort(ventana);

            % Asignar el valor mediano al píxel central
            imagen_filtrada(i, j) = ventana_ordenada(5);
        end
    end
end