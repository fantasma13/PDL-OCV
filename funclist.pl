# define generated functions.
# [ class, name, ismethod(2=attribute), returntype, \%options, @arguments ]
(
['','normalize',0,'void',{},['Mat','mw'],['Mat','out'],['int','start'],['int','end'],['int','type']],
['','minMaxIdx',0,'void',{},['Mat','mw'],["double *","mymin"],["double *","mymax"]],
['','imshow',0,'void',{},['const char *','name'],['Mat','mw']],
['','waitKey',0,'int',{},['int','delay']],
['','namedWindow',0,'void',{},['const char *','winname'],['int','flags']],
['','destroyWindow',0,'void',{},['const char *','winname']],
['','cvtColor',0,'void',{},["Mat","src","",[]],["Mat","dst","",["/O"]],["int","code","",[]],["int","dstCn","0",[]]],
['VideoWriter','fourcc',0,'int',{},['char','c1'],['char','c2'],['char','c3'],['char','c4']],
['VideoWriter','open',1,'char',{},['const char *','name'],['int','fourcc'],['double','fps'],['Size','size'],['char','iscolor']],
['VideoWriter','write',1,'void',{},['Mat','mw']],
['VideoCapture','open',1,'char',{},['const char *','name']],
['VideoCapture','read',1,'char',{},['Mat','mw']],
['VideoCapture','get',1,'double',{},['int','propId']],
['Mat','channels',1,'int',{}],
['Mat','ptr',1,'void *',{}],
['Mat','rows',2,'int',{}],
['Mat','cols',2,'int',{}],
['Mat','convertTo',1,'void',{},['Mat','out'],['int','rtype'],['double','alpha'],['double','beta']],
['','rectangle',0,"void",{},["Mat","img"],["Rect","rec"],["Scalar","color"],["int","thickness"],["int","lineType"],["int","shift"]],
['Tracker','update',1,'char',{pre=>'TRACKER_RECT_TYPE box;',post=>'roi->held = box;',argfix=>sub{$_[0][1]='box'}},['Mat','mw'],['Rect','roi']],
);
