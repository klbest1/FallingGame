//
//  Constant.h
//  SDKSample
//
//  Created by Jeason on 15/7/14.
//
//

#ifndef SDKSample_Constant_h
#define SDKSample_Constant_h

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]

#define TIPSLABEL_TAG 10086
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define BUFFER_SIZE 1024 * 100

static const int kHeadViewHeight = 135;
static const int kSceneViewHeight = 100;

static NSString *kTextMessage = @"人文的东西并不是体现在你看得到的方面，它更多的体现在你看不到的那些方面，它会影响每一个功能，这才是最本质的。但是，对这点可能很多人没有思考过，以为人文的东西就是我们搞一个很小清新的图片什么的。”综合来看，人文的东西其实是贯穿整个产品的脉络，或者说是它的灵魂所在。";

static NSString *kImageTagName = @"WECHAT_TAG_JUMP_APP";
static NSString *kMessageExt = @"这是第三方带的测试字段";
static NSString *kMessageAction = @"<action>dotalist</action>";

static NSString *kLinkURL = @"https://appsto.re/cn/VjVhib.i";
static NSString *kLinkTagName = @"WE_CHAT_LIN_APP";
static NSString *kLinkTitle = @"打你球球：您的好友康林开发的娱乐小游戏";
static NSString *kLinkDescription = @"打你球球操作简单，但考验你的技术和耐心，不是每个人都能打中你的球球❤️。AppStore第一个作品，有兴趣的朋友可以下载下来玩玩。";
static NSString *kLinkImgName = @"ball120.png";

static NSString *kMusicURL = @"http://y.qq.com/i/song.html#p=7B22736F6E675F4E616D65223A22E4B880E697A0E68980E69C89222C22736F6E675F5761704C69766555524C223A22687474703A2F2F74736D7573696334382E74632E71712E636F6D2F586B30305156342F4141414130414141414E5430577532394D7A59344D7A63774D4C6735586A4C517747335A50676F47443864704151526643473444442F4E653765776B617A733D2F31303130333334372E6D34613F7569643D3233343734363930373526616D703B63743D3026616D703B636869643D30222C22736F6E675F5769666955524C223A22687474703A2F2F73747265616D31342E71716D757369632E71712E636F6D2F33303130333334372E6D7033222C226E657454797065223A2277696669222C22736F6E675F416C62756D223A22E4B880E697A0E68980E69C89222C22736F6E675F4944223A3130333334372C22736F6E675F54797065223A312C22736F6E675F53696E676572223A22E5B494E581A5222C22736F6E675F576170446F776E4C6F616455524C223A22687474703A2F2F74736D757369633132382E74632E71712E636F6D2F586C464E4D313574414141416A41414141477A4C36445039536A457A525467304E7A38774E446E752B6473483833344843756B5041576B6D48316C4A434E626F4D34394E4E7A754450444A647A7A45304F513D3D2F33303130333334372E6D70333F7569643D3233343734363930373526616D703B63743D3026616D703B636869643D3026616D703B73747265616D5F706F733D35227D";
static NSString *kMusicDataURL = @"http://stream20.qqmusic.qq.com/32464723.mp3";
static NSString *kMusicTitle = @"一无所有";
static NSString *kMusicDescription = @"崔健";

static NSString *kVideoURL = @"http://v.youku.com/v_show/id_XNTUxNDY1NDY4.html";
static NSString *kVideoTitle = @"乔布斯访谈";
static NSString *kVideoDescription = @"饿着肚皮，傻逼着。";

static NSString *kAPPContentTitle = @"App消息";
static NSString *kAPPContentDescription = @"这种消息只有App自己才能理解，由App指定打开方式";
static NSString *kAppContentExInfo = @"<xml>extend info</xml>";
static NSString *kAppContnetExURL = @"http://weixin.qq.com";
static NSString *kAppMessageExt = @"这是第三方带的测试字段";
static NSString *kAppMessageAction = @"<action>dotaliTest</action>";

static NSString *kAuthScope = @"snsapi_message,snsapi_userinfo,snsapi_friend,snsapi_contact";
static NSString *kAuthOpenID = @"0c806938e2413ce73eef92cc3";
static NSString *kAuthState = @"dropPushing";

static NSString *kFileTitle = @"iphone4.pdf";
static NSString *kFileDescription = @"Pro CoreData";
static NSString *kFileExtension = @"pdf";
static NSString *kFileName = @"iphone4";

static const NSInteger kRecvGetMessageReqAlertTag = 1000;
static const NSInteger kProfileAppIdAlertTag = 2000;
static const NSInteger kProfileUserNameAlertTag = 3000;
static const NSInteger kBizWebviewAppIdAlerttag = 4000;
static const NSInteger kBizWebviewTousernameAlertTag = 6000;
static const NSInteger kOpenUrlAlertTag = 7000;
static const NSInteger kOpenHBAppidAlertTag = 8000;
static const NSInteger kOpenHBPackageAlertTag = 8001;
static const NSInteger kOpenHBSignAlertTag = 8002;

static NSString *kProfileExtMsg = @"http://we.qq.com/d/AQCIc9a3EqRfb19z8WnLB6iFNCxX5bO2S3lHwMQL";
static NSString *kBizWebviewExtMsg = @"KOoCKdavezBjdj2wJZsq67N2j_g3XEQ5JP_pkLhBYS4";

static NSString *kWeiChatAppID = @"wx3b2de6f3fe33e6f0";
static NSString *kWeiChatSecret = @"f6c76b45c9baae55cc71964bf8fb6085";
#endif
