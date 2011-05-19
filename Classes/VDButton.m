//
// Copyright 2010-2011 Vincent Demay
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//


#import "VDButton.h"

@interface VDButton (Private)
- (void) drawUnselected:(CGRect) rect ;
- (void) drawGradient:(CGRect) rect withColor1:(UIColor*) start andColor2:(UIColor*) end;
- (void)drawReflexive:(CGRect)rect andColor:(UIColor *) color;
- (CGGradientRef)newGradientWithColors:(UIColor**)colors locations:(CGFloat*)locations count:(int)count;
- (CGGradientRef)newGradientWithColors:(UIColor**)colors count:(int)count;
@end


@implementation VDButton

@synthesize image;
@synthesize from = _from, to = _to, style = _style;

- (void) dealloc
{
	[image release];
	image = nil;
	[_from release];
	_from = nil;
	[_to release];
	_to = nil;
	[super dealloc];
}


//overidde
- (void)drawRect:(CGRect)rect {
	if (image) {
		UIImage *_mask = image;
		
		CGContextRef ctx = UIGraphicsGetCurrentContext();
		CGContextSaveGState(ctx);
		
		// Translate context upside-down to invert the clip-to-mask, which turns the mask upside down
		CGContextTranslateCTM(ctx, 0, rect.size.height);
		CGContextScaleCTM(ctx, 1.0, -1.0);
		
		CGRect maskRect = CGRectMake(0, 0, _mask.size.width, _mask.size.height);
		CGContextClipToMask(ctx, maskRect, _mask.CGImage);
		if (self.selected) {
			if (_style == VDTabBarGradientStyle) {
				[self drawGradient:rect withColor1:self.to andColor2:self.from];
			} else {
				if (_from) {
					[self drawReflexive:rect andColor:self.from];
				} else {
					[self drawReflexive:rect andColor:[UIColor colorWithRed:0 green:150.0/255.0 blue:1 alpha:1]];
				}
			}
		} else {
			[self drawUnselected:rect];
		}
		CGContextRestoreGState(ctx);
	}
}

- (void) drawUnselected:(CGRect) rect {
	[self drawGradient:rect 
			withColor1:[UIColor colorWithRed:93.0/255.0 green:93.0/255.0 blue:93.0/255.0 alpha:1]
			 andColor2:[UIColor colorWithRed:162.0/255.0 green:162.0/255.0 blue:162.0/255.0 alpha:1]];
}

-(void) drawGradient:(CGRect) rect withColor1:(UIColor*) start andColor2:(UIColor*) end{
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	
	CGContextSaveGState(ctx);
	CGContextClip(ctx);
	
	UIColor* colors[] = {start, end};
	CGGradientRef gradient = [self newGradientWithColors:colors count:2];
	CGContextDrawLinearGradient(ctx, gradient, CGPointMake(rect.origin.x, rect.origin.y),
								CGPointMake(rect.origin.x, rect.origin.y+rect.size.height),
								kCGGradientDrawsAfterEndLocation);
	CGGradientRelease(gradient);
	
	CGContextRestoreGState(ctx);
}

- (void)drawReflexive:(CGRect)rect andColor:(UIColor *) color{
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	
	CGContextSaveGState(ctx);
	CGContextClip(ctx);
	
	// Draw the background color
	[color setFill];
	CGContextFillRect(ctx, rect);
	
	// The highlights are drawn using an overlayed, semi-transparent gradient.
	// The values here are absolutely arbitrary. They were nabbed by inspecting the colors of
	// the "Delete Contact" button in the Contacts app.
	UIColor* topStartHighlight = [UIColor colorWithWhite:1.0 alpha:0.685];
	UIColor* topEndHighlight = [UIColor colorWithWhite:1.0 alpha:0.13];
	UIColor* clearColor = [UIColor colorWithWhite:1.0 alpha:0.0];
	
	UIColor* botEndHighlight;
	if( NO ) {
		botEndHighlight = [UIColor colorWithWhite:1.0 alpha:0.27];
	} else {
		botEndHighlight = clearColor;
	}
	
	UIColor* colors[] = {
		topStartHighlight, topEndHighlight,
		clearColor,
		clearColor, botEndHighlight};
	CGFloat locations[] = {0, 0.5, 0.5, 0.6, 1.0};
	
	CGGradientRef gradient = [self newGradientWithColors:colors locations:locations count:5];
	CGContextDrawLinearGradient(ctx, gradient, CGPointMake(rect.origin.x, rect.origin.y),
								CGPointMake(rect.origin.x, rect.origin.y+rect.size.height), 0);
	CGGradientRelease(gradient);
	
	CGContextRestoreGState(ctx);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGGradientRef)newGradientWithColors:(UIColor**)colors locations:(CGFloat*)locations
                                 count:(int)count {
	CGFloat* components = malloc(sizeof(CGFloat)*4*count);
	for (int i = 0; i < count; ++i) {
		UIColor* color = colors[i];
		size_t n = CGColorGetNumberOfComponents(color.CGColor);
		const CGFloat* rgba = CGColorGetComponents(color.CGColor);
		if (n == 2) {
			components[i*4] = rgba[0];
			components[i*4+1] = rgba[0];
			components[i*4+2] = rgba[0];
			components[i*4+3] = rgba[1];
		} else if (n == 4) {
			components[i*4] = rgba[0];
			components[i*4+1] = rgba[1];
			components[i*4+2] = rgba[2];
			components[i*4+3] = rgba[3];
		}
	}
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGColorSpaceRef space = CGBitmapContextGetColorSpace(context);
	CGGradientRef gradient = CGGradientCreateWithColorComponents(space, components, locations, count);
	free(components);
	
	return gradient;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGGradientRef)newGradientWithColors:(UIColor**)colors count:(int)count {
	return [self newGradientWithColors:colors locations:nil count:count];
}

@end
