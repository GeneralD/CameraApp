#import "GPUImageFilter.h"

// This outputs an image with a constant color. You need to use -forceProcessingAtSize: in order to set the filter image
// dimensions, or this won't work correctly


@interface GPUImageSolidColorGenerator : GPUImageFilter
{
    GLint colorUniform;
    GLint useExistingAlphaUniform;
}

// This color dictates what the filter image will be filled with
@property(readwrite, nonatomic) GPUVector4 color;
@property(readwrite, nonatomic, assign) BOOL useExistingAlpha; // whether to use the alpha of the existing image or not, default is NO

- (void)setColorRed:(GLfloat)redComponent green:(GLfloat)greenComponent blue:(GLfloat)blueComponent alpha:(GLfloat)alphaComponent;

@end
