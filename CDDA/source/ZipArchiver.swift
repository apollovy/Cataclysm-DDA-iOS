//
//  ZipArchiver.swift
//  CDDA
//
//  Created by Аполлов Юрий Андреевич on 20.03.2021.
//  Copyright © 2021 Аполлов Юрий Андреевич. All rights reserved.
//

import Foundation
import Zip


class ZipArchiver : NSObject
{
    @objc class func zip(_ source: URL, destination: URL, errorPtr: NSErrorPointer, progress: @escaping ((_ progress: Double) -> ()))
    {
        do
        {
            let contentItemNames = try FileManager.default.contentsOfDirectory(atPath: source.path).filter({ (itemName) -> Bool in
                return itemName != "config"
            }).map({ (itemName) -> URL in
                source.appendingPathComponent("/\(itemName)")
            })
            try Zip.zipFiles(paths: contentItemNames, zipFilePath: destination, password: nil, progress: progress)
        }
        catch
        {
            errorPtr?.pointee = error as NSError
        }
    }
    
    @objc class func unzip(_ source: URL, destination: URL, errorPtr: NSErrorPointer, progress: @escaping ((_ progress: Double) -> ()))
    {
        do
        {
            try Zip.unzipFile(_: source, destination: destination, overwrite: true, password: nil, progress: progress)
        }
        catch
        {
            errorPtr?.pointee = error as NSError
        }
    }
}
