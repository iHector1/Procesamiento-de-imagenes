% Carga la imagen binaria
Ib = imread('https://i0.wp.com/nlm2019.wordpress.com/wp-content/uploads/2017/11/ciudad.jpg?w=519&h=360&ssl=1'); % Asegúrate de que la imagen esté en blanco y negro


% Se obtienen las dimensiones de la imagen binaria
[m, n] = size(Ib);

% La imagen binaria se convierte a double para que pueda contener valores mayores a 1.
Ibd = double(Ib);

% PASO 1: Se asignan etiquetas iniciales
e = 2;
k = 1;

% Se recorre la imagen de izquierda a derecha y de arriba a abajo
for r = 2:m-1
    for c = 2:n-1
        % Si los píxeles vecinos son ceros se asigna una etiqueta y se incrementa el numero de etiquetas.
        if Ibd(r, c) == 1
            if Ibd(r, c-1) == 0 && Ibd(r-1, c) == 0
                Ibd(r, c) = e;
                e = e + 1;
            end
            % Si uno de los píxeles vecinos tiene una etiqueta asignada, esta etiqueta se le asigna al píxel actual.
            if (Ibd(r, c-1) > 1 && Ibd(r-1, c) < 2) || (Ibd(r, c-1) < 2 && Ibd(r-1, c) > 1)
                if Ibd(r, c-1) > 1
                    Ibd(r, c) = Ibd(r, c-1);
                end
                if Ibd(r-1, c) > 1
                    Ibd(r, c) = Ibd(r-1, c);
                end
            end
            % Si varios de los píxeles vecinos tienen una etiqueta asignada, se le asigna una de ellas a este píxel.
            if Ibd(r, c-1) > 1 && Ibd(r-1, c) > 1
                Ibd(r, c) = Ibd(r-1, c);
                % Las etiquetas no usadas son registradas como colisiones
                if Ibd(r, c-1) ~= Ibd(r-1, c)
                    ec1(k) = Ibd(r-1, c);
                    ec2(k) = Ibd(r, c-1);
                    k = k + 1;
                end
            end
        end
    end
end

% PASO 2: Se resuelven colisiones
for ind = 1:k-1
    % Se detecta la etiqueta más pequeña de las que participan en la colisión. El grupo píxeles pertenecientes a la etiqueta menor absorben a los de la etiqueta mayor.
    if ec1(ind) <= ec2(ind)
        for r = 1:m
            for c = 1:n
                if Ibd(r, c) == ec2(ind)
                    Ibd(r, c) = ec1(ind);
                end
            end
        end
    end
    if ec1(ind) > ec2(ind)
        for r = 1:m
            for c = 1:n
                if Ibd(r, c) == ec1(ind)
                    Ibd(r, c) = ec2(ind);
                end
            end
        end
    end
end

% Se utilizan los valores únicos de la matriz Ibd después de resolver las colisiones
w = unique(Ibd);
t = length(w);

% PASO 3: Re-etiquetado de la imagen
% Se re-etiquetan los píxeles con los valores mínimos.
for r = 1:m
    for c = 1:n
        for ix = 2:t
            if Ibd(r, c) == w(ix)
                Ibd(r, c) = ix-1;
            end
        end
    end
end

% Se preparan los datos para despliegue
E = mat2gray(Ibd);
imshow(E);