//
//  LJImage.swift
//  iMessageKeyboard
//
//  Created by 杰刘 on 2018/5/21.
//  Copyright © 2018年 刘杰. All rights reserved.
//

import UIKit
extension UIImage {
    
    //缩小图片的尺寸
    func reSizeImage(reSize:CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(reSize, false, UIScreen.main.scale)
        self.draw(in: CGRect.init(x: 0, y: 0, width: reSize.width, height: reSize.height))
        let reSizeImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return reSizeImage
    }
    
    /**
     *  等比率缩放
     */
    func scaleImage(scaleSize:CGFloat)->UIImage {
        let reSize = CGSize.init(width: self.size.width * scaleSize, height: self.size.height * scaleSize)
        return reSizeImage(reSize: reSize)
    }

//    截取图片
    func imageFromImage(inRect:CGRect) -> UIImage {
        
        let scale = UIScreen.main.scale
        let x = inRect.origin.x * scale,y = inRect.origin.y * scale,w = inRect.size.width * scale,h = inRect.size.height * scale
        let dianRect = CGRect.init(x: x, y: y, width: w, height: h)
        let sourceImageRef:CGImage = self.cgImage!
        let imageref = sourceImageRef.cropping(to: dianRect)
        let newImage = UIImage.init(cgImage: imageref!, scale: UIScreen.main.scale, orientation: UIImageOrientation.up)
        return newImage
    }
    
    //调整图片的方向
    func fixOrientation() -> UIImage {
        if self.imageOrientation == .up {
            return self
        }
        var transform = CGAffineTransform.identity
        switch self.imageOrientation {
        case .down,.downMirrored:
            transform = transform.translatedBy(x: self.size.width, y: self.size.height)
            transform = transform.rotated(by: CGFloat(M_PI))
        case .left,.leftMirrored:
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.rotated(by: CGFloat(M_PI_2))
            
        case .right,.rightMirrored:
            transform = transform.translatedBy(x: 0, y: self.size.height)
            transform = transform.rotated(by: CGFloat(-M_PI_2))
            
        default:
            break
        }
        switch self.imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: self.size.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        default:
            break
        }
        
        
        let ctx = CGContext(data: nil, width: Int(self.size.width), height: Int(self.size.height), bitsPerComponent: self.cgImage!.bitsPerComponent, bytesPerRow: 0, space: self.cgImage!.colorSpace!, bitmapInfo: self.cgImage!.bitmapInfo.rawValue)
        ctx!.concatenate(transform)
        switch self.imageOrientation {
        case .left,.leftMirrored,.rightMirrored,.right:
            ctx?.draw(self.cgImage!, in: CGRect(x :0,y:0,width:self.size.height,height: self.size.width))
            
        default:
            ctx?.draw(self.cgImage!, in: CGRect(x :0,y:0,width:self.size.width,height: self.size.height))
        }
        let cgimg = ctx!.makeImage()
        let img = UIImage(cgImage: cgimg!)
        return img
    }

    
    ///  抠图效果
    ///
    /// - Parameter maskImage: 不规整的透明图
    /// - Returns: 新的图片
    func maskImage(maskImage:UIImage) -> UIImage {
        
        let maskRef:CGImage = maskImage.cgImage!
        
        let mask = CGImage.init(maskWidth: maskRef.width, height: maskRef.height, bitsPerComponent: maskRef.bitsPerComponent, bitsPerPixel: maskRef.bitsPerPixel, bytesPerRow: maskRef.bytesPerRow, provider: maskRef.dataProvider!, decode: nil, shouldInterpolate: false)
        let sourceImage:CGImage = self.cgImage!
        var imageWithAlpha = sourceImage
        //add alpha channel for images that don't have one (ie GIF, JPEG, etc...)
        //this however has a computational cost
        if sourceImage.alphaInfo == CGImageAlphaInfo.none {
            imageWithAlpha = sourceImage.copy()!
        }
        let masked = sourceImage.masking(mask!)
        //这里是释放了生成的 mask   swift 已经去掉了消灭方法
        UIImage.init(cgImage: mask!)
        
        //release imageWithAlpha if it was created by CopyImageAndAddAlphaChannel
        
        if sourceImage != sourceImage {
            UIImage.init(cgImage: imageWithAlpha)
        }
        
        let retImage = UIImage.init(cgImage: masked!)
        UIImage.init(cgImage: masked!)
        
        return retImage
    }
    
    
    
}
