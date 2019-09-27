
#import <Foundation/Foundation.h>
#import "JSON.h"
#import "WebServiceUrl.h"
#import <UIKit/UIKit.h>


#define ContactUsTag 1
#define sendImgTag 2
#define FaceMapTag 3
#define FaceAuthTag 4
#define FaceEnrlTag 5
#define LivenessTag 6
#define SaveDataTag 7
#define DelEnrlTag 8
#define SingleEnrlTag 9
#define GetDataTag 10
#define FaceMatchTag 11


@interface WebAPIRequest : NSObject

+ (void)sendImage:(NSObject *)delegate
              img:(UIImage *)img
           isFrom:(NSString *)isFrom;



@end
