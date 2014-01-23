//// General Declarations
CGContextRef context = UIGraphicsGetCurrentContext();

//// Color Declarations
UIColor* lightYellow = [UIColor colorWithRed: 0.98 green: 0.812 blue: 0.639 alpha: 1];
UIColor* shadowColor2 = [UIColor colorWithRed: 0.976 green: 0.702 blue: 0.427 alpha: 1];
UIColor* black = [UIColor colorWithRed: 0.196 green: 0.196 blue: 0.196 alpha: 1];
UIColor* darkYellow = [UIColor colorWithRed: 0.831 green: 0.541 blue: 0.255 alpha: 1];
UIColor* color = [UIColor colorWithRed: 0.831 green: 0.541 blue: 0.255 alpha: 1];
UIColor* mediumHeavyYellow = [UIColor colorWithRed: 0.941 green: 0.659 blue: 0.376 alpha: 1];
UIColor* mediumYellow = [UIColor colorWithRed: 0.976 green: 0.702 blue: 0.427 alpha: 1];
UIColor* counterDarkBorderColor = [UIColor colorWithRed: 0.882 green: 0.584 blue: 0.286 alpha: 1];
UIColor* counterLightBorderColor = [UIColor colorWithRed: 0.922 green: 0.631 blue: 0.341 alpha: 1];
UIColor* color3 = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];
UIColor* darkFontYellow = [UIColor colorWithRed: 0.78 green: 0.459 blue: 0.137 alpha: 1];
UIColor* lightGreyText = [UIColor colorWithRed: 0.565 green: 0.565 blue: 0.565 alpha: 1];
UIColor* lightLightYellowText = [UIColor colorWithRed: 1 green: 0.949 blue: 0.902 alpha: 1];

//// Shadow Declarations
UIColor* shadow = shadowColor2;
CGSize shadowOffset = CGSizeMake(0.1, 8.1);
CGFloat shadowBlurRadius = 0;
UIColor* counterDarkBorder = counterDarkBorderColor;
CGSize counterDarkBorderOffset = CGSizeMake(4.1, -0.1);
CGFloat counterDarkBorderBlurRadius = 0;
UIColor* counterLightBorder = counterLightBorderColor;
CGSize counterLightBorderOffset = CGSizeMake(4.1, -0.1);
CGFloat counterLightBorderBlurRadius = 0;

//// Abstracted Attributes
NSString* textContent = @"Home, Work";
NSString* text2Content = @"13.2 mi";
NSString* text4Content = @"0";
NSString* text3Content = @"1";
NSString* text5Content = @"Medium Traffic";
NSString* text6Content = @"via I-5 S";
NSString* text7Content = @"HR";
NSString* text8Content = @"MIN";


//// Rectangle Drawing
UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect: CGRectMake(234, 0, 406, 177)];
[lightYellow setFill];
[rectanglePath fill];

////// Rectangle Inner Shadow
CGRect rectangleBorderRect = CGRectInset([rectanglePath bounds], -shadowBlurRadius, -shadowBlurRadius);
rectangleBorderRect = CGRectOffset(rectangleBorderRect, -shadowOffset.width, -shadowOffset.height);
rectangleBorderRect = CGRectInset(CGRectUnion(rectangleBorderRect, [rectanglePath bounds]), -1, -1);

UIBezierPath* rectangleNegativePath = [UIBezierPath bezierPathWithRect: rectangleBorderRect];
[rectangleNegativePath appendPath: rectanglePath];
rectangleNegativePath.usesEvenOddFillRule = YES;

CGContextSaveGState(context);
{
    CGFloat xOffset = shadowOffset.width + round(rectangleBorderRect.size.width);
    CGFloat yOffset = shadowOffset.height;
    CGContextSetShadowWithColor(context,
        CGSizeMake(xOffset + copysign(0.1, xOffset), yOffset + copysign(0.1, yOffset)),
        shadowBlurRadius,
        shadow.CGColor);

    [rectanglePath addClip];
    CGAffineTransform transform = CGAffineTransformMakeTranslation(-round(rectangleBorderRect.size.width), 0);
    [rectangleNegativePath applyTransform: transform];
    [[UIColor grayColor] setFill];
    [rectangleNegativePath fill];
}
CGContextRestoreGState(context);



//// Rectangle 2 Drawing
UIBezierPath* rectangle2Path = [UIBezierPath bezierPathWithRect: CGRectMake(0, 177, 640, 158)];
[black setFill];
[rectangle2Path fill];


//// Rectangle 4 Drawing
UIBezierPath* rectangle4Path = [UIBezierPath bezierPathWithRect: CGRectMake(-3, 0, 237, 8)];
[darkYellow setFill];
[rectangle4Path fill];


//// Text Drawing
CGRect textRect = CGRectMake(265, 47, 365, 52);
NSMutableParagraphStyle* textStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
[textStyle setAlignment: NSTextAlignmentLeft];

NSDictionary* textFontAttributes = @{NSFontAttributeName: [UIFont fontWithName: @"SourceSansPro-Regular" size: 36], NSForegroundColorAttributeName: color, NSParagraphStyleAttributeName: textStyle};

[textContent drawInRect: textRect withAttributes: textFontAttributes];


//// Text 2 Drawing
CGRect text2Rect = CGRectMake(266, 91, 283, 60);
NSMutableParagraphStyle* text2Style = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
[text2Style setAlignment: NSTextAlignmentLeft];

NSDictionary* text2FontAttributes = @{NSFontAttributeName: [UIFont fontWithName: @"SourceSansPro-Light" size: 34], NSForegroundColorAttributeName: color, NSParagraphStyleAttributeName: text2Style};

[text2Content drawInRect: text2Rect withAttributes: text2FontAttributes];


//// Rectangle 5 Drawing
UIBezierPath* rectangle5Path = [UIBezierPath bezierPathWithRect: CGRectMake(1, 8, 74, 111)];
CGContextSaveGState(context);
CGContextSetShadowWithColor(context, counterDarkBorderOffset, counterDarkBorderBlurRadius, counterDarkBorder.CGColor);
[mediumHeavyYellow setFill];
[rectangle5Path fill];
CGContextRestoreGState(context);



//// Rectangle 6 Drawing
UIBezierPath* rectangle6Path = [UIBezierPath bezierPathWithRect: CGRectMake(79, 8, 74, 111)];
CGContextSaveGState(context);
CGContextSetShadowWithColor(context, counterLightBorderOffset, counterLightBorderBlurRadius, counterLightBorder.CGColor);
[mediumYellow setFill];
[rectangle6Path fill];
CGContextRestoreGState(context);



//// Text 4 Drawing
CGRect text4Rect = CGRectMake(4, 97, 74, 70);
NSMutableParagraphStyle* text4Style = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
[text4Style setAlignment: NSTextAlignmentCenter];

NSDictionary* text4FontAttributes = @{NSFontAttributeName: [UIFont fontWithName: @"OSP-DIN" size: 64], NSForegroundColorAttributeName: darkFontYellow, NSParagraphStyleAttributeName: text4Style};

[text4Content drawInRect: text4Rect withAttributes: text4FontAttributes];


//// Rectangle 7 Drawing
UIBezierPath* rectangle7Path = [UIBezierPath bezierPathWithRect: CGRectMake(156, 8, 74, 111)];
CGContextSaveGState(context);
CGContextSetShadowWithColor(context, counterLightBorderOffset, counterLightBorderBlurRadius, counterLightBorder.CGColor);
[mediumYellow setFill];
[rectangle7Path fill];
CGContextRestoreGState(context);



//// Text 3 Drawing
CGRect text3Rect = CGRectMake(2, 31, 74, 70);
NSMutableParagraphStyle* text3Style = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
[text3Style setAlignment: NSTextAlignmentCenter];

NSDictionary* text3FontAttributes = @{NSFontAttributeName: [UIFont fontWithName: @"OSP-DIN" size: 64], NSForegroundColorAttributeName: color3, NSParagraphStyleAttributeName: text3Style};

[text3Content drawInRect: text3Rect withAttributes: text3FontAttributes];


//// Rectangle 3 Drawing
UIBezierPath* rectangle3Path = [UIBezierPath bezierPathWithRect: CGRectMake(-3, 119, 237, 58)];
[darkYellow setFill];
[rectangle3Path fill];


//// Text 5 Drawing
CGRect text5Rect = CGRectMake(39, 205, 342, 51);
NSMutableParagraphStyle* text5Style = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
[text5Style setAlignment: NSTextAlignmentCenter];

NSDictionary* text5FontAttributes = @{NSFontAttributeName: [UIFont fontWithName: @"SourceSansPro-Light" size: 34], NSForegroundColorAttributeName: lightGreyText, NSParagraphStyleAttributeName: text5Style};

[text5Content drawInRect: text5Rect withAttributes: text5FontAttributes];


//// Text 6 Drawing
CGRect text6Rect = CGRectMake(107, 256, 299, 51);
NSMutableParagraphStyle* text6Style = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
[text6Style setAlignment: NSTextAlignmentLeft];

NSDictionary* text6FontAttributes = @{NSFontAttributeName: [UIFont fontWithName: @"SourceSansPro-Regular" size: 34], NSForegroundColorAttributeName: color3, NSParagraphStyleAttributeName: text6Style};

[text6Content drawInRect: text6Rect withAttributes: text6FontAttributes];


//// Text 7 Drawing
CGRect text7Rect = CGRectMake(-16, 132, 113, 51);
NSMutableParagraphStyle* text7Style = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
[text7Style setAlignment: NSTextAlignmentCenter];

NSDictionary* text7FontAttributes = @{NSFontAttributeName: [UIFont fontWithName: @"SourceSansPro-Light" size: 24], NSForegroundColorAttributeName: lightLightYellowText, NSParagraphStyleAttributeName: text7Style};

[text7Content drawInRect: text7Rect withAttributes: text7FontAttributes];


//// Text 8 Drawing
CGRect text8Rect = CGRectMake(100, 132, 113, 51);
NSMutableParagraphStyle* text8Style = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
[text8Style setAlignment: NSTextAlignmentCenter];

NSDictionary* text8FontAttributes = @{NSFontAttributeName: [UIFont fontWithName: @"SourceSansPro-Light" size: 24], NSForegroundColorAttributeName: lightLightYellowText, NSParagraphStyleAttributeName: text8Style};

[text8Content drawInRect: text8Rect withAttributes: text8FontAttributes];


