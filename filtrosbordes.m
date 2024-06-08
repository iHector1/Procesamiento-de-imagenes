  kernel_prewitt_X = [
            -1, 0, 1
            -1, 0, 1
            -1, 0, 1
        ];
    
    kernel_prewitt_Y = [
            -1, -1, -1
             0,  0,  0
             1,  1,  1
        ];
    
    kernel_sobel_X = [
            -1, 0, 1
            -2, 0, 2
            -1, 0, 1
        ];
    
    kernel_sobel_Y = [
            -1, -2, -1
             0,  0,  0
             1,  2,  1
        ];
    
    kernel_roberts_X = [
            0,  0, 0
            0,  0, 1
            0, -1, 0
        ];
    
    kernel_roberts_Y = [
            -1,  0,  0
             0,  1,  0
             0,  0,  0
        ];
    function [Bordes] = Deteccion_Canny (Imagen_original, Umbral_alto, Umbral_bajo)

    Imagen_filtrada = Imagen_original(1:1:end,1:1:end);
    Imagen_filtrada = double(Imagen_filtrada);
    Filtrado = imfilter(Imagen_filtrada, H);
    
    Hx = [-1 0 1; -2 0 2; -1 0 1];
    Hy = [-1 -2 -1 ; 0 0 0; 1 2 1];
    Gx = abs(imfilter(Imagen_filtrada, Hx));
    Gy = abs(imfilter(Imagen_filtrada, Hy));
    
    Magnitud = sqrt(Gx.^2 + Gy.^2);
    Teta = atand(Gy./ Gx);
    
    Teta = round(Teta);
    Teta = mod(Teta + 180, 180);
    
    [M, N] = size(Magnitud);
    No_maximos = zeros(M-2, N-2);
    
    for i = 2:M-1
        for j = 2:N-1
            switch(Teta(i,j))
                case 0
                    [~,m] = max([Magnitud(i,j-1) Magnitud(i,j) Magnitud(i,j+1)]);
                    if (m==2)
                        No_maximos(i-1,j-1) = Magnitud(i,j);
                    end
                case 45
                    [~,m] = max([Magnitud(i+1,j-1) Magnitud(i,j) Magnitud(i-1,j+1)]);
                    if (m==2)
                        No_maximos(i-1,j-1) = Magnitud(i,j);
                    end
                case 90
                    [~,m] = max([Magnitud(i-1,j) Magnitud(i,j) Magnitud(i+1,j)]);
                    if (m==2)
                        No_maximos(i-1,j-1) = Magnitud(i,j);
                    end
                case 135
                    [~,m] = max([Magnitud(i-1,j-1) Magnitud(i,j) Magnitud(i+1,j+1)]);
                    if (m==2)
                        No_maximos(i-1,j-1) = Magnitud(i,j);
                    end
            end
        end
    end
    
    Bordes = No_maximos;
    
    [M, N] = size(No_maximos);
    Binaria = zeros(M, N);
    
    for i = 1:M
        for j = 1:N
            if(No_maximos(i,j) >= Umbral_alto)
                Binaria(i,j) = 1;
            elseif(No_maximos(i,j) > Umbral_bajo && No_maximos(i,j) < Umbral_alto)
                Binaria(i,j) = 0.5;
            end
        end
    end
    
    Bordes = Binaria;
    
    Bordes_temp = zeros(M+2, N+2);
    Bordes_temp(2:M+1, 2:N+1) = Binaria;
    
    for i = 2:M+1
        for j = 2:N+1
            if(Bordes_temp(i,j) == 0.5)
                if((Bordes_temp(i-1,j-1)==1)||(Bordes_temp(i-1,j)==1)||(Bordes_temp(i-1,j+1)==1)||(Bordes_temp(i,j-1)==1)||(Bordes_temp(i,j+1)==1)||(Bordes_temp(i+1,j-1)==1)||(Bordes_temp(i+1,j)==1)||(Bordes_temp(i+1,j+1)==1))
                    Binaria(i-1,j-1)=1;
                end
            end
        end
    end
    
    Bordes = Binaria;
    
    end
    
    function Gradiente = Funcion_Borde(Imagen, Kernel_X, Kernel_Y)
    
    [m, n] = size(Imagen);
    Imagen = double(Imagen);
    Gx = zeros(size(Imagen));
    Gy = zeros(size(Imagen));
    
    for r = 2:m-1
        for c = 2:n-1
            Submatriz = Imagen(r-1:r+1, c-1:c+1);
            Gx(r, c) = sum(Submatriz .* Kernel_X, 'all');
            Gy(r, c) = sum(Submatriz .* Kernel_Y, 'all');
        end
    end
    
    Gt = sqrt(Gx.^2 + Gy.^2);
    Vmax_Gt = max(max(Gt));
    Gradiente = (Gt / Vmax_Gt) * 255;
    Gradiente = uint8(Gradiente);
    
    end
    
  
    
    Imagen = imread("https://images2.minutemediacdn.com/image/upload/c_fill,w_1200,ar_4:3,f_auto,q_auto,g_auto/shape/cover/sport/legos-hero-0eaaf09e995d184255040705b42f46f4.jpg");
    Imagen = gray(Imagen);
    
    Prewitt_Img = Funcion_Borde(Imagen, kernel_prewitt_X, kernel_prewitt_Y);
    Sobel_Img = Funcion_Borde(Imagen, kernel_sobel_X, kernel_sobel_Y);
    Roberts_Img = Funcion_Borde(Imagen, kernel_roberts_X, kernel_roberts_Y);
    Canny_Img = Deteccion_Canny(Imagen, 1, 10);
    