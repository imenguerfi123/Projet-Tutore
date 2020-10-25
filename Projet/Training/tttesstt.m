clear all
close all
clc

im1 = double(imread('image2.jpg'));
im1=double(im2bw(im1));

% read in query image
% im2 = double(imread('image1.png'));
% im2=double(rgb2gray(im2));

[glcma,SIa] = graycomatrix(im1)
% [glcmb,SIb] = graycomatrix(im2,'GrayLimits', [0 256],'NumLevels', 8, 'Offset', [0 1; -1 1; -1 0;-1 -1]);
