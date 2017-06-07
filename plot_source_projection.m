% h = plot_source_projection(leadfield, sourceIdx, varargin)
%
%       Plots the projection of the given source using EEGLAB's topoplot.
%
% In:
%       leadfield - the leadfield from which to plot the source
%       sourceIdx - the index of the source in the leadfield to be plotted
%
% Optional (key-value pairs):
%       newfig - (0|1) whether or not to open a new figure window.
%                default: 1
%       orientation - 1-by-3 array of xyz source orientation. default uses
%                     the source's default orientation from the lead field.
%       orientedonly - (0|1) if true, only returns one plot of the given
%                      (or default) orientation, otherwise, plots four: one
%                      in each direction, plus the given (or default)
%                      orientation. default: 0
%       colormap - the color map to use (default: jet)
%
% Out:  
%       h - handle of the generated figure
%
% Usage example:
%       >> lf = lf_generate_fromnyhead;
%       >> plot_source_projection(lf, 1, 'colormap', bone(100))
% 
%                    Copyright 2017 Laurens R Krol
%                    Team PhyPA, Biological Psychology and Neuroergonomics,
%                    Berlin Institute of Technology

% 2017-04-24 First version

% This file is part of Simulating Event-Related EEG Activity (SEREEGA).

% SEREEGA is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.

% SEREEGA is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.

% You should have received a copy of the GNU General Public License
% along with SEREEGA.  If not, see <http://www.gnu.org/licenses/>.

function h = plot_source_projection(leadfield, sourceIdx, varargin)

% parsing input
p = inputParser;

addRequired(p, 'leadfield', @isstruct);
addRequired(p, 'sourceIdx', @isnumeric);

addParamValue(p, 'newfig', 1, @isnumeric);
addParamValue(p, 'orientation', [], @isnumeric);
addParamValue(p, 'orientedonly', 0, @isnumeric);
addParamValue(p, 'colormap', jet(100), @isnumeric);

parse(p, leadfield, sourceIdx, varargin{:})

lf = p.Results.leadfield;
sourceIdx = p.Results.sourceIdx;
newfig = p.Results.newfig;
orientation = p.Results.orientation;
orientedonly = p.Results.orientedonly;
cmap = p.Results.colormap;

if isempty(orientation)
    % getting default orientation
    orientation = lf.orientation(sourceIdx,:);
end

if newfig, h = figure; else h = NaN; end

if ~orientedonly
    % plotting three projections
    subplot(2,2,1); title('projection x'); 
    pos = get(gca, 'Position');
    set(gca, 'Position', [0, pos(2)-.05, .5, pos(4)+.05]);
    topoplot(lf.leadfield(:,sourceIdx,1), lf.chanlocs, 'colormap', cmap);
    
    subplot(2,2,2); title('projection y');
    pos = get(gca, 'Position');
    set(gca, 'Position', [.5, pos(2)-.05, .5, pos(4)+.05]);
    topoplot(lf.leadfield(:,sourceIdx,2), lf.chanlocs, 'colormap', cmap);
    
    subplot(2,2,3); title('projection z');
    pos = get(gca, 'Position');
    set(gca, 'Position', [0, pos(2)-.05, .5, pos(4)+.05]);    
    topoplot(lf.leadfield(:,sourceIdx,3), lf.chanlocs, 'colormap', cmap);
    
    subplot(2,2,4);
    pos = get(gca, 'Position');
    set(gca, 'Position', [.5, pos(2)-.05, .5, pos(4)+.05]);
end

% getting oriented projection
meanProj = [];
meanProj(:,1) = lf.leadfield(:,sourceIdx,1) * orientation(1);
meanProj(:,2) = lf.leadfield(:,sourceIdx,2) * orientation(2);
meanProj(:,3) = lf.leadfield(:,sourceIdx,3) * orientation(3);
meanProj = mean(meanProj, 2);

title(sprintf('orientation [%.2f, %.2f, %.2f]', orientation(1), orientation(2), orientation(3))); topoplot(meanProj, lf.chanlocs, 'colormap', cmap);

end