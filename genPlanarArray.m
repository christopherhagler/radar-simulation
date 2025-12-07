function pos_ENU = genPlanarArray(numChan, spacing)
    % 1. Determine dimensions (assume square array)
    sideLen = sqrt(numChan);
    
    % Validation: Ensure it is a perfect square
    if mod(sideLen, 1) ~= 0
        error('Error: numChan (%d) is not a perfect square. Cannot create a square grid.', numChan);
    end

    % 2. Create the axis coordinates
    % We start at 0 so the first element is the phase center reference (0,0,0)
    axis_coords = (0:sideLen-1) * spacing;

    % 3. Generate the 2D Mesh
    % Grid_X varies along columns (East)
    % Grid_Y varies along rows (North)
    [Grid_Y, Grid_Z] = meshgrid(axis_coords, axis_coords);

    % 4. Create X coordinates (Flat array = 0)
    Grid_X = zeros(size(Grid_Y));

    % 5. Flatten and arrange into 3xN matrix
    % result is [x1 x2...; y1 y2...; z1 z2...]
    pos_ENU = [Grid_X(:), Grid_Y(:), Grid_Z(:)];

end