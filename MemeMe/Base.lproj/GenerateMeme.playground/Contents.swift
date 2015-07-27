//: Playground - noun: a place where people can play

import UIKit

var top = "TOP T"
var bottom = "BOTTOM"
let inImage = UIImage(named: "Picard-Wtf.jpg")!
let defaultFontSize: CGFloat = 35.0

//let atPoint = CGPoint((inImage.size.width * .1), (inImage.size.height * .1))

let topRectOrigin = CGPoint(x: CGFloat(), y: inImage.size.height * CGFloat(0))
let bottomRectOrigin = CGPoint(x: CGFloat(), y: inImage.size.height)

//var imageView = UIImageView(image: image)


//Setup the image context using the passed image.
UIGraphicsBeginImageContext(inImage.size)

let paraStyle = NSMutableParagraphStyle()
paraStyle.alignment = NSTextAlignment.Center


//Setups up the font attributes that will be later used to dictate how the text should be drawn
var textFontAttributes = [
    NSStrokeColorAttributeName : UIColor.blackColor(),
    NSForegroundColorAttributeName : UIColor.whiteColor(),
    NSParagraphStyleAttributeName: paraStyle,
    
    NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: inImage.size.height / 10)!,
    NSStrokeWidthAttributeName : NSNumber(float: -3.0)
]



//let stringSize: CGSize = top.sizeWithAttributes(textFontAttributes)
let topStringSize = top.boundingRectWithSize( CGSizeMake(inImage.size.width, CGFloat.max), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes:textFontAttributes, context:nil).size

let bottomStringSize = bottom.boundingRectWithSize( CGSizeMake(inImage.size.width, CGFloat.max), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes:textFontAttributes, context:nil).size

var size = inImage.size.height / 2.0 * 0.75

//Put the image into a rectangle as large as the original image.
inImage.drawInRect(CGRectMake(0, 0, inImage.size.width, inImage.size.height))

// Creating a point within the space that is as bit as the image.
var topRect: CGRect = CGRectMake(topRectOrigin.x, topRectOrigin.y + inImage.size.height*0.05 , inImage.size.width, inImage.size.height/2.0)
var bottomRect: CGRect = CGRectMake(bottomRectOrigin.x, bottomRectOrigin.y - bottomStringSize.height - inImage.size.height*0.05,  inImage.size.width, inImage.size.height)



//Now Draw the text into an image.
top.drawInRect(topRect, withAttributes: textFontAttributes)
bottom.drawInRect(bottomRect, withAttributes: textFontAttributes)

// Create a new image out of the images we have created
var newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()

// End the context now that we have the image we need
UIGraphicsEndImageContext()

//And pass it back up to the caller.
newImage

