function [Z, present] = Encoder_block(X, weights, hyperParameters)
%   [X, present] = block(X, past, weights, hyperParameters) computes a
%   GPT-2 style transformer block on the input X as described in [1] (see
%   Section 2.3). One difference between this style of transformer block
%   and others is that this block uses layer normalization at the
%   beginning.
%
%   Inputs:
%       X               - A (numFeatures*numHeads)-by-numInputSubwords
%                         input array.
%       past            - A numFeatures-by-numPastSubwords-by-numHeads-by-2
%                         array. This contains the 'keys' and 'values' for
%                         past subwords. These are needed to predict future
%                         outputs in an autoregressive manner. 'keys' are
%                         stored in past(:,:,:,1) and 'values' are stored
%                         in past(:,:,:,2).
%       weights         - The weights for the transformer block stored in a
%                         struct. In this block we have:
%                           - ln_1_g_0: Weight vector for the first layer
%                             normalization.
%                           - ln_1_b_0: Bias vector for the first layer
%                             normalization.
%                           - ln_2_g_0: Weight vector for the second layer
%                             normalization.
%                           - ln_2_b_0: Bias vector for the second layer
%                             normalization.
%                         In the attention sub-block:
%                           - attn_c_attn_w_0: A weight matrix for the
%                             first fully connected layer.
%                           - attn_c_attn_b_0: A bias vector for the first
%                             fully connected layer.
%                           - attn_c_proj_w_0: A weight matrix for the
%                             final fully connected layer.
%                           - attn_c_proj_b_0: A bias vector for the final
%                             fully connected layer.
%                         In the multi-layer perceptron block:
%                           - mlp_c_fc_w_0: A weight matrix for the first
%                             fully connected layer.
%                           - mlp_c_fc_b_0: A bias vector for the first
%                             fully connected layer.
%                           - mlp_c_proj_w_0: A weight matrix for the
%                             second fully connected layer.
%                           - mlp_c_proj_b_0: A bias vector for the second
%                             fully connected layer.
%       numHeads        - The number of attention heads. This is a
%                         hyper-parameter.
%
%   Outputs:
%       Z               - A (numFeatures*numHeads)-by-numInputSubwords
%                         output array.
%       present         - A numFeatures-by-numAllSubwords-by-numHeads-by-2
%                         array. This contains the 'keys' and 'values' that
%                         are created from inputs. These need to passed
%                         back in as the 'past' input if we want to predict
%                         future outputs in an autoregressive manner. 'keys'
%                         are stored in present(:,:,:,1) and 'values' are
%                         stored in present(:,:,:,2).

[A, present] = transformer_HA02.layer.attention(X, [], weights, hyperParameters); %(numFeatures*numHeads)-by-numInputSubwords-by-1

A = A + X; %(numFeatures*numHeads)-by-numInputSubwords-by-1

A = transformer_HA02.layer.normalization(A, ...
    weights.ln_1_g_0, weights.ln_1_b_0);

Z = transformer_HA02.layer.FeedforwardNN(A, weights);

Z = Z + A;

Z = transformer_HA02.layer.normalization(Z, ...
    weights.ln_2_g_0, weights.ln_2_b_0);

end