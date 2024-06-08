% Crear una imagen binaria de ejemplo
binaryImage = [
    0 0 0 0 0 0 0 0 0;
    0 1 1 0 0 0 1 1 0;
    0 1 1 0 0 0 1 1 0;
    0 0 0 0 1 1 1 0 0;
    0 1 1 0 0 0 1 1 0;
    0 1 1 0 0 0 1 1 0;
    0 0 0 0 0 0 0 0 0;
];

% Primera pasada
[labeledImage, label, equivalences] = firstPass(binaryImage);

% Segunda pasada
labeledImage = secondPass(labeledImage, equivalences);

% Mostrar la imagen etiquetada final
imshow(labeledImage, []);
title('Imagen Etiquetada Final');

% Mostrar el número de objetos
numObjects = max(labeledImage(:));
numObjects;

function [labeledImage, label] = firstPass(binaryImage)
    % Dimensiones de la imagen
    [rows, cols] = size(binaryImage);

    % Inicializar la matriz de etiquetas
    labeledImage = zeros(rows, cols);

    % Inicializar la etiqueta actual
    label = 0;

    % Diccionario para las equivalencias
    equivalences = containers.Map('KeyType', 'double', 'ValueType', 'any');

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
                else
                    % Asignar la etiqueta mínima de los vecinos
                    minLabel = min(neighbors);
                    labeledImage(r, c) = minLabel;

                    % Registrar equivalencias
                    for neighbor = neighbors
                        if neighbor ~= minLabel
                            if isKey(equivalences, neighbor)
                                equivalences(neighbor) = unique([equivalences(neighbor), minLabel]);
                            else
                                equivalences(neighbor) = minLabel;
                            end
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
function labeledImage = secondPass(labeledImage, equivalences)
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
end

function root = findRoot(equivalences, label)
    if isKey(equivalences, label)
        root = equivalences(label);
        if root ~= label
            root = findRoot(equivalences, root);
        end
    else
        root = label;
    end
end
