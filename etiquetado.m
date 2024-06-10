% Crear una imagen binaria de ejemplo
binaryImage = imread('figuras.png');
binaryImage = rgb2gray(binaryImage);
binaryImage = imbinarize(binaryImage);

% Ejecutar la primera pasada
[labeledImage, equivalences] = firstPass(binaryImage);

% Segunda pasada
[labeledImage, numObjects] = secondPass(labeledImage, equivalences);

% Mostrar el número de objetos
numObjects
figure(1);
sgtitle(['objetos: ', num2str(numObjects)]);
subplot(1, 2, 1), imshow(binaryImage), title('Original');
subplot(1, 2, 2), imshow(label2rgb(labeledImage)), title('objetos detectados');

function [labeledImage, equivalences] = firstPass(binaryImage)
    % Dimensiones de la imagen
    [rows, cols] = size(binaryImage);

    % Inicializar la matriz de etiquetas
    labeledImage = zeros(rows, cols);

    % Inicializar la etiqueta actual
    label = 0;

    % Inicializar la estructura de equivalencias
    equivalences = {};

    % Recorrer la imagen
    for r = 1:rows
        for c = 1:cols
            if binaryImage(r, c) == 1
                % Obtener etiquetas de los vecinos
                neighbors = getNeighbors(labeledImage, r, c);

                if isempty(neighbors)
                    % Asignar una nueva etiqueta
                    label = label + 1;
                    labeledImage(r, c) = label;
                    equivalences{label} = label;
                else
                    % Asignar la etiqueta mínima de los vecinos
                    minLabel = min(neighbors);
                    labeledImage(r, c) = minLabel;

                    % Registrar equivalencias
                    for neighbor = neighbors
                        if neighbor ~= minLabel
                            equivalences{neighbor} = minLabel;
                        end
                    end
                end
            end
        end
    end
end

function neighbors = getNeighbors(labeledImage, r, c)
    neighbors = [];
    if r > 1 && labeledImage(r-1, c) > 0
        neighbors = [neighbors, labeledImage(r-1, c)];
    end
    if c > 1 && labeledImage(r, c-1) > 0
        neighbors = [neighbors, labeledImage(r, c-1)];
    end
    if r > 1 && c > 1 && labeledImage(r-1, c-1) > 0
        neighbors = [neighbors, labeledImage(r-1, c-1)];
    end
    if r > 1 && c < size(labeledImage, 2) && labeledImage(r-1, c+1) > 0
        neighbors = [neighbors, labeledImage(r-1, c+1)];
    end
end

function [labeledImage, numObjects] = secondPass(labeledImage, equivalences)
    % Dimensiones de la imagen
    [rows, cols] = size(labeledImage);

    % Recorrer la imagen
    for r = 1:rows
        for c = 1:cols
            if labeledImage(r, c) > 0
                labeledImage(r, c) = findRoot(equivalences, labeledImage(r, c));
            end
        end
    end

    % Obtener etiquetas únicas
    uniqueLabels = unique(labeledImage(:));

    % Remover la etiqueta 0
    uniqueLabels(uniqueLabels == 0) = [];

    % Contar el número de objetos
    numObjects = numel(uniqueLabels);
end

function root = findRoot(equivalences, label)
    while equivalences{label} ~= label
        label = equivalences{label};
    end
    root = label;
end
