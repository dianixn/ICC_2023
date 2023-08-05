function Z = FC1(X, W, b)

% convolution1d   A fully connected layer
%
%   Z = convolution1d(X, W, b) applies a fully connected layer.
%
%   Inputs:
%       X   - A numInputFeatures-by-numInputSubwords array.
%       W   - A numOutputFeatures-by-numInputFeatures weight matrix.
%       b   - A numOutputFeatures-by-1 bias vector.
%
%   Output:
%       Z   - A numOutputFeatures-by-numInputSubwords array.

Z = dlmtimes(W,X) + b;

end