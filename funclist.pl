(
['','batchDistance','@brief naive nearest neighbor finder

see http://en.wikipedia.org/wiki/Nearest_neighbor_search
@todo document',0,'void',['Mat','src1','',[]],['Mat','src2','',[]],['Mat','dist','',['/O']],['int','dtype','',[]],['Mat','nidx','',['/O']],['int','normType','NORM_L2',[]],['int','K','0',[]],['Mat','mask','Mat()',[]],['int','update','0',[]],['bool','crosscheck','false',[]]],
['','minMaxLoc','@brief Finds the global minimum and maximum in an array.

The function cv::minMaxLoc finds the minimum and maximum element values and their positions. The
extremums are searched across the whole array or, if mask is not an empty array, in the specified
array region.

The function do not work with multi-channel arrays. If you need to find minimum or maximum
elements across all the channels, use Mat::reshape first to reinterpret the array as
single-channel. Or you may extract the particular channel using either extractImageCOI , or
mixChannels , or split .
@param src input single-channel array.
@param minVal pointer to the returned minimum value; NULL is used if not required.
@param maxVal pointer to the returned maximum value; NULL is used if not required.
@param minLoc pointer to the returned minimum location (in 2D case); NULL is used if not required.
@param maxLoc pointer to the returned maximum location (in 2D case); NULL is used if not required.
@param mask optional mask used to select a sub-array.
@sa max, min, compare, inRange, extractImageCOI, mixChannels, split, Mat::reshape',0,'void',['Mat','src','',[]],['double*','minVal','',['/O']],['double*','maxVal','0',['/O']],['Point*','minLoc','0',['/O']],['Point*','maxLoc','0',['/O']],['Mat','mask','Mat()',[]]],
['','normalize','@brief Normalizes the norm or value range of an array.

The function cv::normalize normalizes scale and shift the input array elements so that
\\f[\\| \\texttt{dst} \\| _{L_p}= \\texttt{alpha}\\f]
(where p=Inf, 1 or 2) when normType=NORM_INF, NORM_L1, or NORM_L2, respectively; or so that
\\f[\\min _I  \\texttt{dst} (I)= \\texttt{alpha} , \\, \\, \\max _I  \\texttt{dst} (I)= \\texttt{beta}\\f]

when normType=NORM_MINMAX (for dense arrays only). The optional mask specifies a sub-array to be
normalized. This means that the norm or min-n-max are calculated over the sub-array, and then this
sub-array is modified to be normalized. If you want to only use the mask to calculate the norm or
min-max but modify the whole array, you can use norm and Mat::convertTo.

In case of sparse matrices, only the non-zero values are analyzed and transformed. Because of this,
the range transformation for sparse matrices is not allowed since it can shift the zero level.

Possible usage with some positive example data:
@code{.cpp}
    vector<double> positiveData = { 2.0, 8.0, 10.0 };
    vector<double> normalizedData_l1, normalizedData_l2, normalizedData_inf, normalizedData_minmax;

    // Norm to probability (total count)
    // sum(numbers) = 20.0
    // 2.0      0.1     (2.0/20.0)
    // 8.0      0.4     (8.0/20.0)
    // 10.0     0.5     (10.0/20.0)
    normalize(positiveData, normalizedData_l1, 1.0, 0.0, NORM_L1);

    // Norm to unit vector: ||positiveData|| = 1.0
    // 2.0      0.15
    // 8.0      0.62
    // 10.0     0.77
    normalize(positiveData, normalizedData_l2, 1.0, 0.0, NORM_L2);

    // Norm to max element
    // 2.0      0.2     (2.0/10.0)
    // 8.0      0.8     (8.0/10.0)
    // 10.0     1.0     (10.0/10.0)
    normalize(positiveData, normalizedData_inf, 1.0, 0.0, NORM_INF);

    // Norm to range [0.0;1.0]
    // 2.0      0.0     (shift to left border)
    // 8.0      0.75    (6.0/8.0)
    // 10.0     1.0     (shift to right border)
    normalize(positiveData, normalizedData_minmax, 1.0, 0.0, NORM_MINMAX);
@endcode

@param src input array.
@param dst output array of the same size as src .
@param alpha norm value to normalize to or the lower range boundary in case of the range
normalization.
@param beta upper range boundary in case of the range normalization; it is not used for the norm
normalization.
@param norm_type normalization type (see cv::NormTypes).
@param dtype when negative, the output array has the same type as src; otherwise, it has the same
number of channels as src and the depth =CV_MAT_DEPTH(dtype).
@param mask optional operation mask.
@sa norm, Mat::convertTo, SparseMat::convertTo',0,'void',['Mat','src','',[]],['Mat','dst','',['/IO']],['double','alpha','1',[]],['double','beta','0',[]],['int','norm_type','NORM_L2',[]],['int','dtype','-1',[]],['Mat','mask','Mat()',[]]],
);
