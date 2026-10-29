% Makenzie Adcock
% SOLAR LAB - Deflectometry
% Phase Map Analysis

clear;
close all;
clc;

%phi h r
    for k = 1:4
        I{k} = double(im2gray(imread(sprintf('ref_h%d.JPG', k))));
    end
    
    phi_h_r = atan2(I{4} - I{2}, I{1} - I{3});
    
    figure;
    imagesc(phi_h_r);
    axis image;
    colorbar;
    title('\phi_{h,r}');

%phi v r

    for k = 1:4
        V{k} = double(im2gray(imread(sprintf('ref_v%d.JPG', k))));
    end
    
    phi_v_r = atan2(V{4} - V{2}, V{1} - V{3});
    
    figure;
    imagesc(phi_v_r);
    axis image;
    colorbar;
    title('\phi_{v,r}');

%phi v o

    for i = 1:4
        A{i} = double(im2gray(imread(sprintf('gloss_v%d.JPG', i))));
    end

    phi_v_o = atan2(A{4} - A{2}, A{1} - A{3});

    figure;
    imagesc(phi_v_o);
    axis image;
    colorbar;
    title('\phi_{v,o}');

%phi h o

    for j = 1:4
        objH{j} = double(im2gray(imread(sprintf('gloss_h%d.JPG', j))));
    end

    phi_h_o = atan2(objH{4} - objH{2}, objH{1} - objH{3});

    figure;
    imagesc(phi_h_o);
    axis image;
    colorbar;
    title('\phi_{h,o}');

%subtractions
rho_v = -angle(exp(1i*(phi_v_o - phi_v_r)));
rho_h = -angle(exp(1i*(phi_h_o - phi_h_r)));

%normal map encoding
    norm_factor = sqrt(rho_v.^2 + rho_h.^2 + 1);
    n_x = rho_v ./ norm_factor;
    n_y = rho_h ./ norm_factor;
    n_z = 1 ./ norm_factor;
    
    %set range 0 to 1
    R = (n_x + 1) / 2;
    G = (n_y + 1) / 2;
    B = (n_z + 1) / 2;
    
    normal_map = cat(3, R, G, B);
    
    figure;
    imshow(normal_map);
    title('Qualitative Surface Normal Map');

%normal for what we wanna see

% Crop region (chose roughly)
x1 = 1800;
x2 = 4000;
y1 = 1200;
y2 = 3000;

% Only use every 40th pixel
step = 40;

nx_crop = n_x(y1:step:y2, x1:step:x2);
ny_crop = n_y(y1:step:y2, x1:step:x2);
nz_crop = n_z(y1:step:y2, x1:step:x2);

% Coordinates
[Xq, Yq] = meshgrid( ...
    x1:step:x2, ...
    y1:step:y2);

% Starting Z position
Zq = zeros(size(Xq));

% Plot normal vectors
figure;

quiver3(Xq, Yq, Zq, ...
    nx_crop, ny_crop, nz_crop);

axis equal;
xlabel('x [pixels]');
ylabel('y [pixels]');
zlabel('Normal z-component');

title('Qualitative Surface Normals');

view(3);