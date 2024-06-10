%mofrologicas de dilatacion y erosion


a = imread("https://images.ecestaticos.com/V3bQa-iSFiYmdCJrW4Sl6BiDnCQ=/160x0:1121x721/1200x900/filters:fill(white):format(jpg)/f.elconfidencial.com%2Foriginal%2F4e3%2F2d3%2F9fe%2F4e32d39fe6e795e7ca81be219653732e.jpg");
pesos = [0.2989,0.5870,0.1140];
apesos = a(:,:,1)*pesos(1)+a(:,:,2)*pesos(2)+a(:,:,3)*pesos(3);
% Convertir a binaria
binaryImage = imbinarize(apesos);

prompt = 'Genera el tamana de la matriz: ';
n = 5;
% Definir un elemento estructurante
structuringElement = true(n, n);

% Aplicar dilatación
dilatedImage = dilate(binaryImage, structuringElement);

% Aplicar erosión
erodedImage = erode(binaryImage, structuringElement);

figure(1);
sgtitle(['Capas: ', num2str(n)]);
subplot(1, 3, 1), imshow(apesos), title('Original');
subplot(1, 3, 2), imshow(dilatedImage), title('Dilatada');
subplot(1, 3, 3), imshow(erodedImage), title('Erosionada');

function dilatedImage = dilate(image, se)
    % Obtiene las dimensiones de la imagen y del elemento estructural
    [rows, cols] = size(image);
    [seRows, seCols] = size(se);
    
    % Calcula los offsets del elemento estructural
    seCenterRow = floor(seRows / 2);
    seCenterCol = floor(seCols / 2);
    
    % Inicializa la imagen dilatada
    dilatedImage = zeros(rows, cols);
    
    % Realiza la dilatación
    for i = 1:rows
        for j = 1:cols
            if image(i, j) == 1
                % Añade la estructura de referencia alrededor del píxel (i, j)
                for m = 1:seRows
                    for n = 1:seCols
                        if se(m, n) == 1
                            row = i + m - seCenterRow - 1;
                            col = j + n - seCenterCol - 1;
                            if row > 0 && row <= rows && col > 0 && col <= cols
                                dilatedImage(row, col) = 1;
                            end
                        end
                    end
                end
            end
        end
    end
end

function erodedImage = erode(image, se)
    % Obtiene las dimensiones de la imagen y del elemento estructural
    [rows, cols] = size(image);
    [seRows, seCols] = size(se);
    
    % Calcula los offsets del elemento estructural
    seCenterRow = floor(seRows / 2);
    seCenterCol = floor(seCols / 2);
    
    % Inicializa la imagen erosionada
    erodedImage = zeros(rows, cols);
    
    % Realiza la erosión
    for i = 1:rows
        for j = 1:cols
            % Verifica si la estructura de referencia encaja en (i, j)
            match = true;
            for m = 1:seRows
                for n = 1:seCols
                    row = i + m - seCenterRow - 1;
                    col = j + n - seCenterCol - 1;
                    if se(m, n) == 1
                        if row <= 0 || row > rows || col <= 0 || col > cols || image(row, col) == 0
                            match = false;
                            break;
                        end
                    end
                end
                if ~match
                    break;
                end
            end
            if match
                erodedImage(i, j) = 1;
            end
        end
    end
end



