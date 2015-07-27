//
//  Meme.swift
//  Image Picker
//
//  Created by Nick Adcock on 7/20/15.
//  Copyright (c) 2015 Nick. All rights reserved.
//

import Foundation
import UIKit

struct Meme {
    var top: String!
    var bottom: String!
    var image: UIImage!
    
    func generateMeme() -> UIImage {
        let topRectOrigin = CGPoint(x: CGFloat(), y: image.size.height * CGFloat(0))
        let bottomRectOrigin = CGPoint(x: CGFloat(), y: image.size.height)
        
        //Setup the image context using the passed image.
        UIGraphicsBeginImageContext(image.size)
        
        let paraStyle = NSMutableParagraphStyle()
        paraStyle.alignment = NSTextAlignment.Center
        
        //Setups up the font attributes that will be later used to dictate how the text should be drawn
        let textFontAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSParagraphStyleAttributeName: paraStyle,
        
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: image.size.height / 10)!,
            NSStrokeWidthAttributeName : NSNumber(float: -3.0)
        ]
        
        // Finds the size of the rect the text will draw with the attributes
        let topStringSize = top.boundingRectWithSize(CGSizeMake(image.size.width, CGFloat.max), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: textFontAttributes, context: nil).size
        let bottomStringSize = bottom.boundingRectWithSize(CGSizeMake(image.size.width, CGFloat.max), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: textFontAttributes, context: nil).size
        
        //Put the image into a rectangle as large as the original image.
        image.drawInRect(CGRectMake(0, 0, image.size.width, image.size.height))
        
        // Creating a point within the space that is as bit as the image.
        var topRect: CGRect = CGRectMake(topRectOrigin.x, topRectOrigin.y + image.size.height * 0.05 , image.size.width, image.size.height/2.0)
        var bottomRect: CGRect = CGRectMake(bottomRectOrigin.x, bottomRectOrigin.y - bottomStringSize.height - image.size.height * 0.05, image.size.width, image.size.height/2.0)
        
        //Now Draw the text into an image.
        top.drawInRect(topRect, withAttributes: textFontAttributes)
        bottom.drawInRect(bottomRect, withAttributes: textFontAttributes)
        
        // Create a new image out of the images created
        var newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // End the context
        UIGraphicsEndImageContext()
        
        //And pass it back up to the caller.
        return newImage
    }
}


