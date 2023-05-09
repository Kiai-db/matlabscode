objectFind = imread('tony.jpeg');
objectFind = rgb2gray(objectFind);
figure;
imshow(objectFind);
title('Object to find');

objectInScene = imread('scene.jpeg');
objectInScene = rgb2gray(objectInScene);
figure; 
imshow(objectInScene);
title('Object in scene');

objectFindPoints = detectSURFFeatures(objectFind);
objectInScenePoints = detectSURFFeatures(objectInScene);

figure; 
imshow(objectFind);
title('Features');
hold on;
plot(selectStrongest(objectFindPoints, 200));

figure; 
imshow(objectInScene);
title('Feature Points');
hold on;
plot(selectStrongest(objectInScenePoints, 500));

[obFeatures, obPoints] = extractFeatures(objectFind, objectFindPoints);
[picFeatures, picPoints] = extractFeatures(objectInScene, objectInScenePoints);


obMatch = matchFeatures(obFeatures, picFeatures);

matchedObPoints = obPoints(obMatch(:, 1), :);
matchedPicPoints = picPoints(obMatch(:, 2), :);
figure;
showMatchedFeatures(objectFind, objectInScene, matchedObPoints, matchedPicPoints, 'montage');
title('Points that were found to match');

[tform, inlierIdx] = estgeotform2d(matchedObPoints, matchedPicPoints, 'affine');
corrObPoints   = matchedObPoints(inlierIdx, :);
corrPicPoints = matchedPicPoints(inlierIdx, :);


figure;
showMatchedFeatures(objectFind, objectInScene, corrObPoints, corrPicPoints, 'montage');
title('Matched Points without annomalies');


objectPolygon = [1, 1; size(objectFind, 2), 1; size(objectFind, 2), size(objectFind, 1); 1, size(objectFind, 1); 1, 1];       

newObPolygon = transformPointsForward(tform, objectPolygon);   


figure;
imshow(objectInScene);
hold on;
line(newObPolygon(:, 1), newObPolygon(:, 2), Color='y');
title('Detected Object');
