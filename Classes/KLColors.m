


#import "KLColors.h"
#import "KLGraphicsUtils.h"

// Colors derived from Apple's calendar
CGColorRef kSlateBlueColor, kGridDarkColor, kGridLightColor, kCheckmarkColor,
           kCalendarHeaderLightColor, kCalendarHeaderDarkColor,
           kCalendarBodyLightColor, kCalendarBodyDarkColor,
           kLightCharcoalColor, kDarkCharcoalColor,
           kTileRegularTopColor, kTileRegularBottomColor,
		   kTileDimTopColor, kTileDimBottomColor;

// Basic grayscale colors
CGColorRef kBlackColor, kWhiteColor;


__attribute__((constructor))  // Makes this function run when the app loads
static void InitKColors()
{
    kSlateBlueColor = CreateRGB(0.451f, 0.537f, 0.647f, 1.0f);
    kGridDarkColor = CreateRGB(68.0/255.0, 92.0/255.0, 94.0/255.0, 1.0);//CreateRGB(0.667f, 0.682f, 0.714f, 1.0f);
    kGridLightColor = CreateRGB(0.953f, 0.953f, 0.961f, 1.0f);
    kCalendarHeaderLightColor = CreateRGB(68.0/255.0, 92.0/255.0, 94.0/255.0, 1.0);//CreateRGB(0.965f, 0.965f, 0.969f, 1.0f);
    kCalendarHeaderDarkColor = CreateRGB(68.0/255.0, 92.0/255.0, 94.0/255.0, 1.0);//CreateRGB(0.808f, 0.808f, 0.824f, 1.0f);
    kCalendarBodyLightColor = CreateRGB(0.890f, 0.886f, 0.898f, 1.0f);
    kCalendarBodyDarkColor = CreateRGB(0.784f, 0.748f, 0.804f, 1.0f);
    kLightCharcoalColor = CreateRGB(0.3f, 0.3f, 0.3f, 1.0f);
    kDarkCharcoalColor = CreateRGB(0.1f, 0.1f, 0.1f, 1.0f);
    kTileRegularTopColor = CreateRGB(0.173f, 0.212f, 0.255f, 1.0f);
    kTileRegularBottomColor = CreateRGB(0.294f, 0.361f, 0.435f, 1.0f);
    kTileDimTopColor = CreateRGB(0.545f, 0.565f, 0.588f, 1.0f);
    kTileDimBottomColor = CreateRGB(0.600f, 0.635f, 0.675f, 1.0f);
	
	kBlackColor = CreateGray(0.0f, 1.0f);
    kWhiteColor = CreateGray(1.0f, 1.0f);
}

CGColorRef CreateGray(CGFloat gray, CGFloat alpha)
{
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceGray();
    CGFloat components[2] = {gray, alpha};
    CGColorRef color = CGColorCreate(colorspace, components);
    CGColorSpaceRelease(colorspace);
    return color;
}

CGColorRef CreateRGB(CGFloat red, CGFloat green, CGFloat blue, CGFloat alpha)
{
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    CGFloat components[4] = {red, green, blue, alpha};
    CGColorRef color = CGColorCreate(colorspace, components);
    CGColorSpaceRelease(colorspace);
    return color;
}



