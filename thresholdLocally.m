function B = thresholdLocally(A, blksz, varargin)

if ~nargin
    error('THRESHOLDLOCALLY: Requires at least one input argument.')
end

if ischar(A)
    A = imread(A);
end

% DEFAULTS
% M                = 32;
% N                = 32;
[M, N] = bestblk(size(A));
opts.BorderSize  = [6 6];
opts.PadPartialBlocks = true;
opts.PadMethod   = 'replicate';
opts.TrimBorder  = true;
opts.Destination = [];
opts.FudgeFactor = 1;

if nargin > 1 && ~isempty(blksz)
    if numel(blksz) == 1
        M = blksz; N = M;
    elseif numel(blksz) == 2
        M = blksz(1);N = blksz(2);
    else
        error('THRESHOLDLOCALLY: Improper specification of blocksize parameter');
    end
end

if nargin > 2
    opts = parsePV_Pairs(opts,varargin);
end

fun = @(block_struct) im2bw(block_struct.data,...
    min(max(opts.FudgeFactor*graythresh(block_struct.data),0),1));

if isempty(opts.Destination)
    B = blockproc(A,[M N],fun,...
        'BorderSize',opts.BorderSize,...
        'PadPartialBlocks',opts.PadPartialBlocks,...
        'PadMethod',opts.PadMethod,...
        'TrimBorder',opts.TrimBorder);
else
    B = [];
    blockproc(A,[M N],fun,...
        'BorderSize',opts.BorderSize,...
        'PadPartialBlocks',opts.PadPartialBlocks,...
        'PadMethod',opts.PadMethod,...
        'TrimBorder',opts.TrimBorder,...
        'Destination',opts.Destination);
end

end

function opts = parsePV_Pairs(opts,UserInputs)
    ind = find(strcmpi(UserInputs,'BorderSize'));
    if ~isempty(ind)
        opts.BorderSize = UserInputs{ind + 1};
    end
    ind = find(strcmpi(UserInputs,'PadPartialBlocks'));
    if ~isempty(ind)
        opts.PadPartialBlocks = UserInputs{ind + 1};
    end
    ind = find(strcmpi(UserInputs,'PadMethod'));
    if ~isempty(ind)
        opts.PadMethod = UserInputs{ind + 1};
    end
    ind = find(strcmpi(UserInputs,'TrimBorder'));
    if ~isempty(ind)
        opts.TrimBorder = UserInputs{ind + 1};
    end
    ind = find(strcmpi(UserInputs,'Destination'));
    if ~isempty(ind)
        opts.Destination = UserInputs{ind + 1};
    end
    ind = find(strcmpi(UserInputs,'FudgeFactor'));
    if ~isempty(ind)
        opts.FudgeFactor = UserInputs{ind + 1};
    end
end
