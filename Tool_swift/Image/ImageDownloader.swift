//
//  ImageDownloader.swift
//  iMessageKeyboard
//
//  Created by 杰刘 on 2018/5/10.
//  Copyright © 2018年 刘杰. All rights reserved.
//

import UIKit

class ImageDownloader: NSObject {
    
    // 单粒
    static let shared = ImageDownloader()
    // 内存缓存图片，根据图片操作
    var cacheImages:Dictionary<String, Any> = [:]
    // 保存回调闭包
    var completionDict = [String:(image:UIImage) -> Void]()
    // 队列
    var queue:OperationQueue = {
        let queue = OperationQueue.init()
        queue.maxConcurrentOperationCount = 4
        return queue
    }()

    func downloadImage(filename:String,url:String,completion:@escaping (_ image:UIImage)->Void) {
        
        completionDict[url] = completion
        // 从内存缓存中取图片
        let cacheImage = cacheImages[url] as! UIImage?
        if cacheImage != nil {
            if completionDict[url] != nil {
                completionDict[url]!(cacheImage!)
                return
            }
        }
        
        // 从沙盒cache中获取图片
        let cachePath = url.cacheDir(name: filename)
        print(cachePath)
//        let sanboxData = NSData.init(contentsOfFile: cachePath)
        
        let sanboxData = NSData.init(contentsOfFile: cachePath.path)
        if (sanboxData != nil) {
            let sandboxImage = UIImage.init(data: sanboxData! as Data)
            
            // 保存到内存缓存
            cacheImages[url] = sandboxImage
            // 回调
            if completionDict[url] != nil {
                completionDict[url]!(sandboxImage!)
                return
            }
        }
        
        // 内存和沙盒中均没有图片，开始下载
        queue.addOperation {
            let downloadData = NSData.init(contentsOf: URL.init(string: url)!)
            let downloadImage = UIImage.init(data: downloadData! as Data)
            
            // 回主线程
            OperationQueue.main.addOperation {
                // 回调
                if self.completionDict[url] != nil {
                    self.completionDict[url]!(downloadImage!)
                }
                
                // 保存到内存
                self.cacheImages[url] = downloadImage
                // 保存到沙盒
//                downloadData?.write(to: URL.init(fileURLWithPath: cachePath), atomically: true)
              let hh = downloadData?.write(toFile: cachePath.path, atomically: true)
                print("是否写入正确 ：\(hh)")
            }
        }
    }

    
}
extension String {
    //name  为文件夹的名称 -》emoji群组
    //self  为emoji 的名字 ——》单个emoji
    
    func cacheDir(name:String) -> URL {

        print(self)
        let fileManager = FileManager.default
        var fileUrl = fileManager.containerURL(forSecurityApplicationGroupIdentifier: "group.text.emoji")
        fileUrl = fileUrl?.appendingPathComponent("Library/Caches/" + name)
        
        let exist = fileManager.fileExists(atPath: fileUrl!.path)
        if !exist {
            try! fileManager.createDirectory(at: fileUrl!, withIntermediateDirectories: true,
                                         attributes: nil)
        }
       let filePath = fileUrl?.appendingPathComponent((self as NSString).lastPathComponent)
       
        return filePath!
    }
}
