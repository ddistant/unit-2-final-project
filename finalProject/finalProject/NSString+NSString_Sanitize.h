//
//  NSString+NSString_Sanitize.h
//  finalProject
//
//  Created by Natalia Estrella on 10/16/15.
//  Copyright © 2015 ddistant. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (NSString_Sanitize)

//Cleans up HTML in Mettup API description
-(NSString *)stringByStrippingHTML;

@end
