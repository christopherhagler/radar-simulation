function pos_ENU = genPlanarArray(numChan, spacing, rotX, rotY, rotZ)
    sideLen = sqrt(numChan);

    if mod(sideLen, 1) ~= 0
        error('Error: numChan (%d) is not a perfect square. Cannot create a square grid.', numChan);
    end

    axis_coords = ((0:sideLen-1) - (sideLen-1)/2) * spacing;
    [Grid_Y, Grid_Z] = meshgrid(axis_coords, axis_coords);
    Grid_X = zeros(size(Grid_Y));
    pos_ENU = [Grid_X(:), Grid_Y(:), Grid_Z(:)];
    pos_ENU = rotationXYZExtrinsic(pos_ENU', rotX, rotY, rotZ)';
end