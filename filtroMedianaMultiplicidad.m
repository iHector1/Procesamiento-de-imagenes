% Path: filtroMedianaMultiplicidad.m   
a = imread("imagen.png");
pesos = [0.2989,0.5870,0.1140];
apesos = a(:,:,1)*pesos(1)+a(:,:,2)*pesos(2)+a(:,:,3)*pesos(3);
figure(1)
imshow(apesos)
imageNoise = salt_and_pepper(apesos,0.05);
figure(2)
imshow(imageNoise);
ventana = [1,3,2;
           2,4,1;
           1,2,1];
filtro = filtro_mediana_multiplicidad(imageNoise, ventana);
filtro = filtro_mediana_multiplicidad(filtro, ventana);
figure(3);
imshow(filtro);

function imagen_filtrada = filtro_mediana_multiplicidad(imagen, ventana)
    imagen_filtrada = imagen;
    [filas,columnas] = size(imagen);
    for i=2:filas-1
        for j=2:columnas-1
            % Obtener los valores de intensidad de la ventana en un array
            ventana_imagen = [imagen(i-1, j-1), imagen(i-1, j), imagen(i-1, j+1); 
                              imagen(i, j-1), imagen(i, j), imagen(i, j+1); 
                              imagen(i+1, j-1), imagen(i+1, j), imagen(i+1, j+1)];
            % Convertir la ventana en un array unidimensional
            ventana_imagen = ventana_imagen(:);
            
            % Asociar la imagen con la ventana
            array_asociado = [];
            for k = 1:length(ventana_imagen)
                array_asociado = [array_asociado, repmat(ventana_imagen(k), 1, ventana(k))];
            end
            % Ordenar el array asociado
            array_asociado_ordenado = quicksort(array_asociado);
            
            % Asignar el valor mediano al píxel central
            imagen_filtrada(i, j) = array_asociado_ordenado(round(length(array_asociado_ordenado)/2));
        end
    end
end


%funcion salt and pepper%
function imagen_ruido = salt_and_pepper(imagen, probabilidad)
    imagen_ruido = imagen;
    [filas, columnas] = size(imagen);
    for i=1:filas
        for j=1:columnas
            % Generar un número aleatorio entre 0 y 1
            numero_aleatorio = rand;
            % Si el número aleatorio es menor que la probabilidad
            % asignar un valor de 0 o 255 al píxel
            if numero_aleatorio < probabilidad
                numero_aleatorio = rand;
                if numero_aleatorio < 0.5
                    imagen_ruido(i, j) = 0;
                else
                    imagen_ruido(i, j) = 255;
                end
            end
        end
    end
end

function array_ordenado = quicksort(array)
    if length(array) <= 1
        array_ordenado = array;
    else
        pivot = array(end);
        menor = array(array < pivot);
        igual = array(array == pivot);
        mayor = array(array > pivot);
        array_ordenado = [quicksort(menor), igual, quicksort(mayor)];
    end
end