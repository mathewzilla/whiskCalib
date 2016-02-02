function helloworld
% HELLOWORLD Display the globe and a welcome message.

    % Load the topographical data for the globe
    load('topo.mat', 'topo', 'topomap1');

    % Create a unit sphere with 50 facets. This sphere is the Earth.
    [x,y,z] = sphere(50);

    % Establish initial viewing and lighting parameters. Use Phong shading
    % and texture mapping to wrap the topo map data around the sphere.

    props.FaceColor= 'texture';
    props.EdgeColor = 'none';
    props.FaceLighting = 'phong';
    props.CData = topo;

    % Set the viewpoint to look at the Atlantic Ocean.
    view(-130, 10);

    % Draw the sphere, with the topo data texture mapped to the surface.
    s=surface(x,y,z,props);
    set(gcf, 'Color', 'white');  % White background
    axis square
    axis off
    axis equal

    title('Hello, World.', 'FontSize', 14, 'FontWeight', 'Bold');
end