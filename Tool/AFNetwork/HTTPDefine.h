#ifndef HTTPDefine_h
#define HTTPDefine_h


//#pragma mark-服务器
////金顶线上第七版
//#define Khttp     @"http://120.78.48.105/api/"
//#define kHTTPImg  @"http://120.78.48.105"

////金顶本地测试服务器
#define Khttp @"http://192.168.2.115:8091/api/"
#define kHTTPImg @"http://192.168.2.115:8091"



#define RGBAA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

#define APPDELEGATE ((AppDelegate*)[[UIApplication sharedApplication] delegate])
#endif
