

#import "WebAPIRequest.h"
#import "WebServiceUrl.h"
#import "JSON.h"
#import <UIKit/UIKit.h>

@interface NSObject(Extended)
-(void)setData:(NSString *)message items:(NSString *)items withtag:(int)tag;

@end


@interface ConnectionClass:NSObject{
    NSMutableData *receivedData;
    NSString *className;
    NSString *rootName;
    NSObject *m_delegate;
    
    int tag;
}

-(id)initWithClass:(NSString *)classa withRoot:(NSString *)root withDelegate:(NSObject *)delgate withTag:(int)t;

@end

@implementation ConnectionClass
-(id)initWithClass:(NSString *)classa withRoot:(NSString *)root withDelegate:(NSObject *)delegate withTag:(int)t
{
    m_delegate = delegate;
    className = classa;
    rootName = root;
    tag=t;
    return self;
}

- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)data
{
   
    if (receivedData != nil)
    {
        [receivedData appendData:data];
    } else
    {
        receivedData = [[NSMutableData alloc] initWithData:data];
    }
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *strData = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    //    NSLog(@"Response %@",strData);
    NSDictionary *dictResponse = [strData JSONValue];
    [m_delegate setData:@"" items:strData withtag:tag];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [m_delegate setData:@"Connection required" items:nil withtag:0];
}

@end

@implementation WebAPIRequest


//Post Contact Details
+ (void)sendImage:(NSObject *)delegate
             img:(UIImage *)img
          isFrom:(NSString *)isFrom
{
    int tag = sendImgTag;
    
    NSError *error;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",WS_BaseUrl]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"1544605430AuefLvgk7yWX4nnApjO3f90MRARt9dkmJ4EQFVL7" forHTTPHeaderField:@"Api-Key"];
    NSMutableData *body = [NSMutableData data];
    NSData *imageData1 = UIImageJPEGRepresentation(img, 1.0);
    NSData *imageData =[self compressImage:img];
    NSLog(@"Size of Image(bytes):%ld",(unsigned long)[imageData length]);
    NSLog(@"Size of Image(bytes):%ld",(unsigned long)[imageData1 length]);

    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSMutableDictionary *dictdata=[[NSMutableDictionary alloc]init];
    [dictdata setObject:isFrom forKey:@"card_type"];
    for (NSString *param in dictdata)
    {
        // add params (all params are strings)
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [dictdata objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    if (imageData)
    {
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
        [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
        
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];

          [body appendData:[@"Content-Disposition: form-data; name=\"scan_image\"; filename=\"dr.jpg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[NSData dataWithData:imageData]];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        
        //            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPBody:body];
    ConnectionClass *con = [[ConnectionClass alloc] initWithClass:@"Welcome" withRoot:@"Login" withDelegate:delegate withTag:tag];
      [[[NSURLConnection alloc] initWithRequest:request delegate:con] start];
}

+(UIImage *)compressForUpload:(UIImage *)original scale:(CGFloat)scale
{
    CGSize originalSize = original.size;
    CGSize newSize = CGSizeMake(originalSize.width  *scale, originalSize.height  *scale);
    
    UIGraphicsBeginImageContext(newSize);
    [original drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage* compressedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return compressedImage;
    
}
+(UIImage *)compressImage1:(UIImage *)image{
    
    NSData *imgData = UIImageJPEGRepresentation(image, 1); //1 it represents the quality of the image.
    NSLog(@"Size of Image(bytes):%ld",(unsigned long)[imgData length]);
    
    float actualHeight = image.size.height;
    float actualWidth = image.size.width;
    float maxHeight = 600.0;
    float maxWidth = 800.0;
    float imgRatio = actualWidth/actualHeight;
    float maxRatio = maxWidth/maxHeight;
    float compressionQuality = 0.5;//50 percent compression
    
    
    if (actualHeight > maxHeight || actualWidth > maxWidth){
        if(imgRatio < maxRatio){
            //adjust width according to maxHeight
            imgRatio = maxHeight / actualHeight;
            actualWidth = imgRatio * actualWidth;
            actualHeight = maxHeight;
        }
        else if(imgRatio > maxRatio){
            //adjust height according to maxWidth
            imgRatio = maxWidth / actualWidth;
            actualHeight = imgRatio * actualHeight;
            actualWidth = maxWidth;
        }
        else{
            actualHeight = maxHeight;
            actualWidth = maxWidth;
        }
    }
    
    CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
    UIGraphicsBeginImageContext(rect.size);
    [image drawInRect:rect];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    NSData *imageData = UIImageJPEGRepresentation(img, compressionQuality);
    UIGraphicsEndImageContext();
    
    NSLog(@"Size of Image(bytes):%ld",(unsigned long)[imageData length]);
    
    return [UIImage imageWithData:imageData];
}
+(NSData *)compressImage:(UIImage *)image{
    
    NSData *imgData = UIImageJPEGRepresentation(image, 1); //1 it represents the quality of the image.
    NSLog(@"Size of Image(bytes):%ld",(unsigned long)[imgData length]);
    
    float actualHeight = image.size.height;
    float actualWidth = image.size.width;
    float maxHeight = 600.0;
    float maxWidth = 800.0;
    float imgRatio = actualWidth/actualHeight;
    float maxRatio = maxWidth/maxHeight;
    float compressionQuality = 1.0;//50 percent compression
    
    if (actualHeight > maxHeight || actualWidth > maxWidth){
        if(imgRatio < maxRatio){
            //adjust width according to maxHeight
            imgRatio = maxHeight / actualHeight;
            actualWidth = imgRatio * actualWidth;
            actualHeight = maxHeight;
        }
        else if(imgRatio > maxRatio){
            //adjust height according to maxWidth
            imgRatio = maxWidth / actualWidth;
            actualHeight = imgRatio * actualHeight;
            actualWidth = maxWidth;
        }
        else{
            actualHeight = maxHeight;
            actualWidth = maxWidth;
        }
    }
    
    CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
    UIGraphicsBeginImageContext(rect.size);
    [image drawInRect:rect];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    NSData *imageData = UIImageJPEGRepresentation(img, compressionQuality);
    UIGraphicsEndImageContext();
    
    NSLog(@"Size of Image(bytes):%ld",(unsigned long)[imageData length]);
    
    return imageData;
}
@end
