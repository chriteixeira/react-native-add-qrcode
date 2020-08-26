#import "AddQrcode.h"
#import "React/RCTConvert.h"

@implementation AddQrcode
		
RCT_EXPORT_MODULE()

- (CGImageRef) generateQRCode:(NSString *)data
                    withWidth:(CGFloat)width
                   withHeight:(CGFloat)height
                    withColor:(UIColor *)color
          withBackgroundColor:(UIColor *)backgroundColor {
    
    NSData *stringData = [data dataUsingEncoding: NSUTF8StringEncoding];
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    CIFilter *colorFilter = [CIFilter filterWithName:@"CIFalseColor"];
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    
    CIColor *background = [[CIColor alloc] initWithColor:backgroundColor];
    CIColor *foreground = [[CIColor alloc] initWithColor:color];

    [colorFilter setValue:qrFilter.outputImage forKey:kCIInputImageKey];
    [colorFilter setValue:background forKey:@"inputColor1"];
    [colorFilter setValue:foreground forKey:@"inputColor0"];
    CIImage *qrImage = colorFilter.outputImage;
    
    float scaleX = 1;
    float scaleY = 1;
    if (height) {
      scaleY = height / qrImage.extent.size.height;
    }
    if (width) {
      scaleX = width / qrImage.extent.size.width;
    }
    qrImage = [qrImage imageByApplyingTransform:CGAffineTransformMakeScale(scaleX, scaleY)];
    CIContext *context = [CIContext contextWithOptions:nil];
    return [context createCGImage:qrImage fromRect:[qrImage extent]];
    
}

RCT_EXPORT_METHOD(addQRCodeToImage:(NSString *)imagePath
                  destinationPath:(NSString *)destinationPath
                  data:(NSString *)data
                  options:(NSDictionary *)options
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{

    CGFloat qrX = [RCTConvert CGFloat:options[@"x"]];
    CGFloat qrY = [RCTConvert CGFloat:options[@"y"]];
    CGFloat qrWidth = [RCTConvert CGFloat:options[@"width"]];
    CGFloat qrHeight = [RCTConvert CGFloat:options[@"height"]];
    CGFloat quality = [RCTConvert CGFloat:options[@"quality"]];
    UIColor *backgroundColor = [RCTConvert UIColor:options[@"backgroundColor"]];
    UIColor *foregroundColor = [RCTConvert UIColor:options[@"foregroundColor"]];
       
    NSURL *imageURL = [RCTConvert NSURL:imagePath];
    NSData *imageData = [[NSData alloc] initWithContentsOfURL:imageURL];
    UIImage *image = [[UIImage alloc] initWithData:imageData];
    
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    
    CGContextRef ctx = CGBitmapContextCreate(nil, width, height, CGImageGetBitsPerComponent(image.CGImage), 0, CGImageGetColorSpace(image.CGImage), kCGImageAlphaPremultipliedLast);
    
    CGContextDrawImage(ctx, CGRectMake(0, 0, width, height), image.CGImage);

    CGImageRef qrCGImage = [self generateQRCode:data 
                            withWidth:qrWidth 
                            withHeight:qrHeight
                            withColor:foregroundColor
                            withBackgroundColor:backgroundColor];
    CGContextDrawImage(ctx, CGRectMake(qrX, qrY, qrWidth, qrHeight), qrCGImage);
        
    CGImageRef cgImage = CGBitmapContextCreateImage(ctx);
    CGContextRelease(ctx);
    
    NSData* resultImageData = [NSData dataWithData:UIImageJPEGRepresentation([UIImage imageWithCGImage:cgImage], quality)];
    NSError *writeError = nil;
    [resultImageData writeToFile:destinationPath options:NSDataWritingAtomic error:&writeError];
        
    resolve(@{
        @"uri":destinationPath,
        @"finalWidth":[NSNumber numberWithFloat:width],
        @"finalHeight":[NSNumber numberWithFloat:height]
        });
}

@end
