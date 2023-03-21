(
['KeyPoint',[],'@brief Data structure for salient point detectors.

The class instance stores a keypoint, i.e. a point feature found by one of many available keypoint
detectors, such as Harris corner detector, #FAST, %StarDetector, %SURF, %SIFT etc.

The keypoint is characterized by the 2D position, scale (proportional to the diameter of the
neighborhood that needs to be taken into account), orientation and some other parameters. The
keypoint neighborhood is then analyzed by another algorithm that builds a descriptor (usually
represented as a feature vector). The keypoints representing the same object in different images
can then be matched using %KDTree or another method.',0,'cv::KeyPoint',[[[],''],[[['float','x','',[]],['float','y','',[]],['float','size','',[]],['float','angle','-1',[]],['float','response','0',[]],['int','octave','0',[]],['int','class_id','-1',[]]],'@param x x-coordinate of the keypoint
    @param y y-coordinate of the keypoint
    @param size keypoint diameter
    @param angle keypoint orientation
    @param response keypoint detector response on the keypoint (that is, strength of the keypoint)
    @param octave pyramid octave in which the keypoint has been detected
    @param class_id object id']]],
['DMatch',[],'@brief Class for matching keypoint descriptors

query descriptor index, train descriptor index, train image index, and distance between
descriptors.',0,'cv::DMatch',[[[],''],[[['int','_queryIdx','',[]],['int','_trainIdx','',[]],['float','_distance','',[]]],''],[[['int','_queryIdx','',[]],['int','_trainIdx','',[]],['int','_imgIdx','',[]],['float','_distance','',[]]],'']]],
['Algorithm',[],'@brief This is a base class for all more or less complex algorithms in OpenCV

especially for classes of algorithms, for which there can be multiple implementations. The examples
are stereo correspondence (for which there are algorithms like block matching, semi-global block
matching, graph-cut etc.), background subtraction (which can be done using mixture-of-gaussians
models, codebook-based algorithm etc.), optical flow (block matching, Lucas-Kanade, Horn-Schunck
etc.).

Here is example of SimpleBlobDetector use in your application via Algorithm interface:
@snippet snippets/core_various.cpp Algorithm'],
['FileStorage',[],'@brief XML/YAML/JSON file storage class that encapsulates all the information necessary for writing or
reading data to/from a file.',0,'cv::FileStorage',[[[],'@brief The constructors.

     The full constructor opens the file. Alternatively you can use the default constructor and then
     call FileStorage::open.'],[[['String','filename','',['/C','/Ref']],['int','flags','',[]],['String','encoding','String()',['/C','/Ref']]],'@overload
     @copydoc open()']]],
['FileNode',[],'@brief File Storage Node class.

The node is used to store each and every element of the file storage opened for reading. When
XML/YAML file is read, it is first parsed and stored in the memory as a hierarchical collection of
nodes. Each node can be a "leaf" that is contain a single number or a string, or be a collection of
other nodes. There can be named collections (mappings) where each element has a name and it is
accessed by a name, and ordered collections (sequences) where elements do not have names but rather
accessed by index. Type of the file node can be determined using FileNode::type method.

Note that file nodes are only used for navigating file storages opened for reading. When a file
storage is opened for writing, no data is stored in memory after it is written.',0,'cv::FileNode',[[[],'@brief The constructors.

     These constructors are used to create a default file node, construct it from obsolete structures or
     from the another file node.']]],
);
