% Clear the workspace and close all figures
clc; clear; close all;

% Copy your initialization code from the previous version
forestSizeX = 20;
forestSizeY = 20;
forest = zeros(forestSizeX, forestSizeY);
simulationTimeSteps = 1000;

empty = 0;
tree = 1;
fire = 2;
house = 3;

treeGrowthRate = 0.01;
treeDeathRate = 0.001;
fireSparkRate = 0.005;
fireResistance = 0.001;

% Fixed house locations
houseLocations = [5, 5; 10, 15; 15, 8];

% Set houses in the initial forest
for k = 1:size(houseLocations, 1)
    forest(houseLocations(k, 1), houseLocations(k, 2)) = house;
end

% Go through each instant in time
for t = 1:simulationTimeSteps
    % Initialize the forestNext matrix for this iteration
    forestNext = forest;
    
    % Go through every location in your forest
    for i = 2:forestSizeX - 1
        for j = 2:forestSizeY - 1
            % check forest(i,j), and determine if it’s empty, tree, fire, or house
            % based on this, decide if forestNext(i,j) should be set to empty, tree, fire, or house
            
            % Check if the current cell is adjacent to fire and is a house
            if forest(i, j) == house && any(any(forest(i-1:i+1, j-1:j+1) == fire))
                % Determine if the house will burn based on fireResistance
                if rand <= fireResistance
                    forestNext(i, j) = fire; % House catches on fire
                end
            elseif forest(i, j) == empty
                % current cell is empty
                if rand <= treeGrowthRate
                    forestNext(i, j) = tree; % A tree grows in the current cell
                end
            elseif forest(i, j) == tree
                % current cell is a tree
                if rand <= fireSparkRate
                    forestNext(i, j) = fire; % Tree catches on fire
                elseif rand <= treeDeathRate
                    forestNext(i, j) = empty; % Tree dies naturally
                end
            elseif forest(i, j) == fire
                % current cell is on fire
                forestNext(i, j) = empty; % Fire burns out and becomes empty
            end
        end % for j loop
    end % for i loop

    % display the updated forest with proper colors
    imagesc(forestNext);
    clim([empty, house]);
    colorbar;

    % Draw points showing fixed houses on top of the forest for visual
    % clarity
    hold on;
    for k = 1:size(houseLocations, 1)
        plot(houseLocations(k, 2), houseLocations(k, 1), 'o', 'MarkerSize', 10);
    end
    hold off;

    % this next line forces Matlab to update the figure each time through
    % the "for" loop
    drawnow;
    
    % Update the original forest matrix for the next iteration
    forest = forestNext;
end
