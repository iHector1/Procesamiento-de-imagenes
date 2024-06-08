function resultado = aplicarFiltro(imagen, filtro)
    imagen = double(imagen);
    [x, y, ~] = size(imagen);
    resultado = zeros(x, y);
    for r=3:x-2
        for c=3:y-2
            submatriz = imagen(r-2:r+2, c-2:c+2);
            resultado(r, c) = sum(submatriz .* filtro, 'all') / numel(filtro);
        end
    end
end

function imagen = convertirAGris(imagenRGB)
    [m, n, ~] = size(imagenRGB);
    for i = 1: m
        for j = 1: n
            x = (imagenRGB(i,j)*0.299 + imagenRGB(i,j)*0.587 + imagenRGB(i,j)*0.114);
            imagenRGB(i,j,1) = x;
            imagenRGB(i,j,2) = x; 
            imagenRGB(i,j,3) = x;
        end
    end
    imagen = imagenRGB;
end

function resultado = suavizarImagen(imagen, filtro)
    imagen = double(imagen);
    [x, y, ~] = size(imagen);
    resultado = zeros(x, y);
    for r=2:x-1
        for c=2:y-1
            submatriz = imagen(r-1:r+1, c-1:c+1);
            resultado(r, c) = sum(submatriz .* filtro, 'all') / numel(filtro);
        end
    end
end

nucleoLaplace = [  0,  0, -1,  0,  0;
                   0, -1, -2, -1,  0;
                  -1, -2, 16, -2, -1;
                   0, -1, -2, -1,  0;
                   0,  0, -1,  0,  0];

nucleoGaussiano = [ 0, 1, 2, 1, 0;
                    1, 3, 5, 3, 1;
                    2, 5, 9, 5, 2;
                    1, 3, 5, 3, 1;
                    0, 1, 2, 1, 0];

nucleoBox = [ 0, 0, 0, 0, 0;
              0, 1, 1, 1, 0;
              0, 1, 1, 1, 0;
              0, 1, 1, 1, 0;
              0, 0, 0, 0, 0];

nucleoLineal = [ 1, 1, 1;
                 1, 1, 1;
                 1, 1, 1];

imagen = imread("https://imgs.search.brave.com/RM0bVj3h_CsQJfjUgDacXbiptMH2yKSq_jVA7mg2RDI/rs:fit:860:0:0/g:ce/aHR0cHM6Ly9tZWRp/YS5pc3RvY2twaG90/by5jb20vaWQvNjM5/MDgyNDE4L2VzL2Zv/dG8vbGEtZ3Jhbi1p/bWFnZW4uanBnP3M9/NjEyeDYxMiZ3PTAm/az0yMCZjPUhMYmRW/MnQyLW9ZNHlPd0lz/UHFpQkhVT0pFSEpa/UTN0dGM5Uy1uTHp6/OWM9");
figure(1);
imshow(imagen);
imagen = convertirAGris(imagen);
figure(2);
imagen = aplicarFiltro(imagen, nucleoLaplace);
imshow(imagen);
figure(3);
imagen = aplicarFiltro(imagen, nucleoGaussiano);
imshow(imagen);
figure(4);
imagen = aplicarFiltro(imagen, nucleoBox);
imshow(imagen);
figure(5);
imagen = suavizarImagen(imagen, nucleoLineal);
imshow(imagen);
