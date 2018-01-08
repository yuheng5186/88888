#ifndef HTTPDefine_h
#define HTTPDefine_h


//#pragma mark-服务器
//第五版
//#define Khttp       @"http://api.jinding6666.com/api/"
//#define kHTTPImg    @"http://api.jinding6666.com/"

//第六版
//#define Khttp       @"http://api.jdkuaixi.com/api/"
//#define kHTTPImg    @"http://api.jdkuaixi.com"

////金顶线上第七版
#define Khttp     @"http://120.78.48.105/api/"
#define kHTTPImg  @"http://120.78.48.105"

// iOS测试服务器
//金顶本地第四版
//#define Khttp @"http://192.168.2.115:8091/api/"
//#define kHTTPImg @"http://192.168.2.115:8091"

//第三版
//#define Khttp @"http://192.168.2.152:8090/api/"
//
//#define kHTTPImg @"http://192.168.2.152:8090"

//第二版
//#define Khttp @"http://192.168.3.101:8090/api/"
//
//#define kHTTPImg @"http://192.168.3.101:8090"

//第一版
//#define Khttp @"http://192.168.3.80:8090/api/"
//
//#define kHTTPImg @"http://192.168.3.80:8090"



#define RGBAA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

#define APPDELEGATE ((AppDelegate*)[[UIApplication sharedApplication] delegate])
#endif
