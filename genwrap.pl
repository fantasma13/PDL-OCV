use strict;
use warnings;
use File::Spec::Functions;
use PDL::Types;
use PDL::Core qw/howbig/;

# define generated functions.
# [ name, ismethod, returntype, \%options, @arguments ]
my @funclist = (
['normalize',0,'void',{},'MatWrapper *','out','int','start','int','end','int','type'],
['channels',1,'int',{}],
['minMaxIdx',0,'void',{},"double *","mymin","double *","mymax"],
#['mult',0,{},"double *","mymin","double *","mymax"],
#['minMaxLoc',0,'void',{},"double *","mymin","double *","mymax","int *","myminl","int *","mymaxl"],
);

my ($tstr_l,$rstr_l);
for my $type ( grep $_->real, PDL::Types::types ) {
	next if (my $bs = PDL::Core::howbig($type)) > 8;
	next if $type->ppsym =~/[KPQN]/;
	my $nt = $type->numval;
	my $ct = $type->realctype;
	my $tt = $type->integer ? ($type->unsigned ? 'U' : 'S') : 'F';
	my $s = 8*$bs;
	$tstr_l.="\tcase $nt :
		return CV_$s${tt}C(planes); break;\n";
	$rstr_l.="\tcase CV_$s$tt : t = $nt; break;\n";
}

my $rstr="
int get_pdltype(const int cvtype) {
        uchar depth = CV_MAT_DEPTH(cvtype); //    type & CV_MAT_DEPTH_MASK;
        const uchar chans = CV_MAT_CN(cvtype) ; //1 + (cvtype >> CV_CN_SHIFT);
	int t=-1;
	switch(depth) {
$rstr_l\t}
	return t;
}
";

my $tstr="
int get_ocvtype(const int datatype,const int planes) {
	switch (datatype) {
$tstr_l\t}
	return -1;
}
";

sub gen_code {
	my ($name, $ismethod, $ret, $opt) = splice @_, 0, 4;
	my (@args, @cvargs);
	while (@_) {
		my ($s, $v) = (shift, shift);
		$v=~s/^&//;
		push @args, "$s $v";
		push @cvargs, $s =~ /.*Wrapper \*/ ? "$v->held" : $v;
	}
	my $fname=$name;
	my $str = "$ret cw_$name(";
	unshift @args, "MatWrapper * mw";
	$str .= join(", ", @args) . ")";
	my $hstr = $str.";\n";
	$str .= " {\n";
	$str .= "  // pre:\n$$opt{pre}\n" if $$opt{pre};
	$str .= "  ".($ret ne 'void' ? "$ret retval = " : '');
	$str .= ($ismethod ? "mw->held.$name(" : "cv::$name(mw->held@{[@cvargs && ', ']}");
	$str .= join(', ', @cvargs).");\n";
	$str .= "  // post:\n$$opt{post}\n" if $$opt{post};
	$str .= "  return retval;\n" if $ret ne 'void';
	$str .= "}\n\n";
	return ($hstr,$str);
}

open my $fh,">","opencv_wrapper.h" or die "cannot write header file\n";
open my $fc,">","opencv_wrapper.cpp" or die "cannot write C++ file\n";

print $fc sprintf qq{#line %d "%s"\n}, __LINE__ + 2,  __FILE__;
print $fc <<'EOF';
#include "opencv_wrapper.h"
#include <opencv2/opencv.hpp>
#include <opencv2/tracking.hpp>
#include <opencv2/highgui.hpp>
#include <opencv2/imgproc.hpp>
#include <opencv2/videoio.hpp>
#include <opencv2/core/utility.hpp>
#include <opencv2/videoio.hpp>

using namespace std;
/* use C name mangling */
#ifdef __cplusplus
extern "C" {
#endif

void imgImshow(const char *name, MatWrapper *mw) {
	cv::imshow(name,mw->held);
}

struct TrackerWrapper {
	cv::Ptr<cv::Tracker> held;
};

TrackerWrapper * newTracker(int trackerNumber) {
	string trackerTypes[8] = {"BOOSTING", "MIL", "KCF", "TLD","MEDIANFLOW", "GOTURN", "MOSSE", "CSRT"};
	string trackerType = trackerTypes[trackerNumber];
	cv::Ptr<cv::Tracker> tracker;
	if (trackerType == "MIL")
		tracker = cv::TrackerMIL::create();
	if (trackerType == "KCF")
		tracker = cv::TrackerKCF::create();
	if (trackerType == "GOTURN")
		tracker = cv::TrackerGOTURN::create();
	if (trackerType == "CSRT")
		tracker = cv::TrackerCSRT::create();
	TrackerWrapper * Tr= new TrackerWrapper;
	Tr->held = tracker;
	return Tr;
}

int deleteTracker(TrackerWrapper * wrapper) {
	delete wrapper;
	return 1;
}

void initTracker(TrackerWrapper * Tr, MatWrapper * mw, cw_Rect box) {
	cv::Rect roi;
	cv::Mat frame;
	roi.x=box.x;
	roi.y=box.y;
	roi.height=box.height;
	roi.width=box.width;
	double mymin,mymax;
	minMaxIdx(mw->held, & mymin,& mymax);
	double scale = 256/mymax;
	mw->held.convertTo(frame,CV_8UC3,scale);
	if(frame.channels()==1) cvtColor(frame,frame,cv::COLOR_GRAY2RGB);
	if (roi.x == 0) {
		cv::namedWindow("ud",cv::WINDOW_NORMAL);
		roi=cv::selectROI("ud",frame,true,false);
		cv::destroyWindow("ud");
	}
	Tr->held->init(frame,roi);
}

char updateTracker(TrackerWrapper * Tr, MatWrapper * mw, cw_Rect *roi) {
#if CV_VERSION_MINOR >= 5 && CV_VERSION_MAJOR >= 4
	cv::Rect box;
#else
	cv::Rect2d box;
#endif
	cv::Mat frame;
	double mymin,mymax;
	minMaxIdx(mw->held, & mymin,& mymax);
	double scale = 256/mymax;
	mw->held.convertTo(frame,CV_8UC3,scale);
	if(frame.channels()==1) cvtColor(frame,frame,cv::COLOR_GRAY2RGB);
	char res = Tr->held->update(frame,box );
	cv::rectangle( frame, box, cv::Scalar( 255, 0, 0 ), 2, 1 );
	mw->held=frame;
	imgImshow("ud", mw);
	cv::waitKey(1);
	roi->x=box.x;
	roi->y=box.y;
	roi->height=box.height;
	roi->width=box.width;
	return res;
}

int deleteMat(MatWrapper * wrapper) {
	delete wrapper;
	return 1;
}

MatWrapper * emptyMW () {
	return new MatWrapper;
}

MatWrapper * newMat (const ptrdiff_t cols, const ptrdiff_t rows, const int type, int planes, void * data) {
	MatWrapper *mw = new MatWrapper;
	mw->held = cv::Mat(rows, cols, get_ocvtype(type,planes), data);
	return mw;
}

ptrdiff_t cols (MatWrapper * mw) {
	return mw->held.cols;
}

ptrdiff_t rows (MatWrapper * mw) {
	return mw->held.rows;
}

void *matData (MatWrapper * mw) {
	return mw->held.ptr();
}

const char *vDims(MatWrapper *wrapper, ptrdiff_t *t, ptrdiff_t *l, ptrdiff_t *c, ptrdiff_t *r) {
	*c = wrapper->held.cols;
	*r = wrapper->held.rows;
	*t = wrapper->held.type();
	*l = wrapper->held.channels();
	return NULL;
}

struct VideoWriterWrapper {
	cv::VideoWriter held;
};

VideoWriterWrapper *newVideoWriter() {
	return new VideoWriterWrapper;
}

int deleteVideoWriter(VideoWriterWrapper * wrapper) {
	delete wrapper;
	return 1;
}

const char *openVideoWriter(VideoWriterWrapper *wrapper, const char *name, const char *code, double fps, int width, int height, char iscolor) {
	if (!wrapper->held.open(
	  name,
	  cv::VideoWriter::fourcc(code[0],code[1],code[2],code[3]),
	  fps,
	  cv::Size(width, height),
	  iscolor
	)) return "Error opening video write";
	return NULL;
}

void writeVideoWriter(VideoWriterWrapper *wrapper, MatWrapper *mw) {
	wrapper->held.write(mw->held);
}

struct VideoCaptureWrapper {
	cv::VideoCapture held;
};

VideoCaptureWrapper *newVideoCapture() {
	return new VideoCaptureWrapper;
}

int deleteVideoCapture(VideoCaptureWrapper * wrapper) {
	delete wrapper;
	return 1;
}

const char *openVideoCaptureURI(VideoCaptureWrapper *wrapper, const char *uri) {
	wrapper->held.open( uri );
	if (!wrapper->held.isOpened()) return "Error opening video capture";
	return NULL;
}

ptrdiff_t framecountVideoCapture(VideoCaptureWrapper *wrapper) {
	return wrapper->held.get(cv::CAP_PROP_FRAME_COUNT);
}

bool readVideoCapture(VideoCaptureWrapper *wrapper, MatWrapper *mw) {
	return wrapper->held.read(mw->held);
}
EOF

print $fc $tstr;
print $fc $rstr;

print $fh sprintf qq{#line %d "%s"\n}, __LINE__ + 2,  __FILE__;
print $fh <<'EOF';
#ifndef OPENCV_WRAPPER_H
#define OPENCV_WRAPPER_H

#ifdef __cplusplus
#include <vector>
#include <opencv2/opencv.hpp>
struct MatWrapper
{
        cv::Mat held;
};
#endif

#ifdef __cplusplus
extern "C" {
#endif

#include <stddef.h>

typedef struct {
	int x; int y; int width; int height;
} cw_Rect;

typedef struct MatWrapper  MatWrapper ;
ptrdiff_t rows (MatWrapper * mw) ;
ptrdiff_t cols (MatWrapper * mw) ;
void *matData(MatWrapper * mw);
const char *vDims(MatWrapper *wrapper, ptrdiff_t *t, ptrdiff_t *l, ptrdiff_t *c, ptrdiff_t *r);

typedef struct VideoWriterWrapper VideoWriterWrapper;
VideoWriterWrapper *newVideoWriter();
int deleteVideoWriter (VideoWriterWrapper *);
const char *openVideoWriter(VideoWriterWrapper *wrapper, const char *name, const char *code, double fps, int width, int height, char iscolor);
void writeVideoWriter(VideoWriterWrapper *wrapper, MatWrapper *mw);

typedef struct VideoCaptureWrapper VideoCaptureWrapper;
VideoCaptureWrapper *newVideoCapture();
int deleteVideoCapture (VideoCaptureWrapper *);
const char *openVideoCaptureURI(VideoCaptureWrapper * Tr, const char *uri);
ptrdiff_t framecountVideoCapture(VideoCaptureWrapper *wrapper);
bool readVideoCapture(VideoCaptureWrapper *wrapper, MatWrapper *mw);

void imgImshow(const char *name, MatWrapper *mw);

typedef struct TrackerWrapper TrackerWrapper;
TrackerWrapper * newTracker (int tracker_type);
int  deleteTracker (TrackerWrapper *);
void initTracker(TrackerWrapper * Tr, MatWrapper * frame, cw_Rect box);
char updateTracker(TrackerWrapper *, MatWrapper *, cw_Rect *box);

MatWrapper * newMat (const ptrdiff_t cols, const ptrdiff_t rows, const int type, const int planes, void * data);
MatWrapper * emptyMW ();
int deleteMat(MatWrapper * wrapper);

int get_pdltype(const int cvtype);
int get_ocvtype(const int datatype,const int planes);
EOF

for my $func (@funclist) {
	my ($hstr,$cstr) = gen_code( @$func );
	print $fh $hstr;
	print $fc $cstr;
}

print $fh <<'EOF';
#ifdef __cplusplus
}
#endif

#endif
EOF

print $fc <<'EOF';
#ifdef __cplusplus
}
#endif
EOF

close $fh;
close $fc;
