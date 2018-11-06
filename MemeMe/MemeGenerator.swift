//
//  MemeGenerator.swift
//  MemeMe
//
//  Created by Nick Adcock on 2/24/17.
//  Copyright © 2017 Nick. All rights reserved.
//

import Foundation
import UIKit

class MemeGenerator {
    func generateMeme(top: String, bottom: String, image: UIImage) -> Data {
        let topRectOrigin = CGPoint(x: CGFloat(), y: image.size.height * CGFloat(0))
        let bottomRectOrigin = CGPoint(x: CGFloat(), y: image.size.height)
        
        //Setup the image context using the passed image.
        UIGraphicsBeginImageContext(image.size)
        
        let paraStyle = NSMutableParagraphStyle()
        paraStyle.alignment = .center
        
        //Setups up the font attributes that will be later used to dictate how the text should be drawn
        let textFontAttributes = [
            NSAttributedString.Key.strokeColor : UIColor.black,
            NSAttributedString.Key.foregroundColor : UIColor.white,
            NSAttributedString.Key.paragraphStyle: paraStyle,
            
            NSAttributedString.Key.font : UIFont(name: "HelveticaNeue-CondensedBlack", size: image.size.height / 10)!,
            NSAttributedString.Key.strokeWidth : NSNumber(value: -3.0 as Float)
        ]
        
        // Finds the size of the rect the text will draw with the attributes
//        let topStringSize = top.boundingRect(with: CGSize(width: image.size.width, height: CGFloat.greatestFiniteMagnitude), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: textFontAttributes, context: nil).size
        let bottomStringSize = bottom.boundingRect(with: CGSize(width: image.size.width, height: CGFloat.greatestFiniteMagnitude), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: textFontAttributes, context: nil).size
        
        //Put the image into a rectangle as large as the original image.
        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        
        // Creating a point within the space that is as bit as the image.
        let topRect: CGRect = CGRect(x: topRectOrigin.x, y: topRectOrigin.y + image.size.height * 0.05 , width: image.size.width, height: image.size.height/2.0)
        let bottomRect: CGRect = CGRect(x: bottomRectOrigin.x, y: bottomRectOrigin.y - bottomStringSize.height - image.size.height * 0.05, width: image.size.width, height: image.size.height/2.0)
        
        //Now Draw the text into an image.
        top.draw(in: topRect, withAttributes: textFontAttributes)
        bottom.draw(in: bottomRect, withAttributes: textFontAttributes)
        
        // Create a new image out of the images created
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        let imageData: Data = newImage.pngData()!
        
        // End the context
        UIGraphicsEndImageContext()
        
        //And pass it back up to the caller.
        return imageData
    }

}
