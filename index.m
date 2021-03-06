%% Grow Lineages along Minimum Spanning Tree for B Cell Recptor Seqeuence Data
% This page provides some examples of using source code version of GLaMST.


%% Prepare environment
% Set working directory to the upzipped folder. If your matlab does not have
% C/C++ compiler setup, need to first install MinGW, instructions at 
% following link (Home->Add-Ons->search MinGW->install) 
% <https://www.mathworks.com/help/matlab/matlab_external/install-mingw-support-package.html>

restoredefaultpath;
addpath lib
addpath src
mex src/editDist_only.cpp
mex src/backtrace.cpp


%% Simulate data
% Simulate a dataset that 
operation_probability = [0.99 0.005 0.005];% mutation, insertion, deletion chance
sequence_length = 300; % Length of the seqeunces
num_tree_nodes = 200; % Total number of the real tree
sample_size = 100; % Number of observed nodes
rng(42); %% Fix the random seed;
[observed_sequences, true_sequences, adj, is_selected] = simulate_data_v2(...
    sequence_length,num_tree_nodes,sample_size,operation_probability);
draw_hierarchy_tree(adj, is_selected');

%% Run GLaMST and visualize the results
% This section is a example of using GLaMST. You need to pass a variable
% "observed_sequences" that contain a cell array of known sequences to
% function "reconstruct_tree_minimun_tree_size". ** Make sure the first
% sequence of "observed_sequences" should be root(G.L.). **
% "reconstructed_nodes" is a cell array of sequences of the reconstructed
% tree. "reconstructed_is_selected" is the index of tree nodes that known
% before the reconstruction. "reconstructed_directed_adj" is the adjecent
% matrix that represent the hierarchical structure of the tree.
[reconstructed_nodes,mst_adj,reconstructed_is_selected, reconstructed_directed_adj] = ...
    reconstruct_tree_minimun_tree_size(observed_sequences);
draw_hierarchy_tree(reconstructed_directed_adj, reconstructed_is_selected);

%% Write Reconstructed Tree to File
% Use the command below to write the reconstructed tree to file. This
% command will generate two files. In simulated.out.tree
% file, each row coresponds to one single node. First item each row is node
% name and the following items are its children. In simulated.out.fa file,
% all the observed sequences and inserted seqeunces are presented. 
Write_tree_toFile(reconstructed_nodes, reconstructed_directed_adj, reconstructed_is_selected, 'simulated');

%% Generate lineage tree from real data
% Given this data is not yet publicly avaliable, we have simulated a
% dataset that has exactly the same topology as used in our paper ( with
% sequences order shuffled and nucleobase exchenged). This simulated data
% is avaliable here
% <https://github.com/xysheep/GLaMST/blob/master/demodata>.
fsa = fastaread('demodata/real.fasta');
observed_sequences = {fsa.Sequence}';

[reconstructed_nodes,mst_adj,reconstructed_is_selected, reconstructed_directed_adj] = ...
    reconstruct_tree_minimun_tree_size(observed_sequences);
draw_hierarchy_tree(reconstructed_directed_adj, reconstructed_is_selected);
