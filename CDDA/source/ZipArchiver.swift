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
            try Zip.zipFiles(paths: [source], zipFilePath: destination, password: nil, progress: progress)
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
            try Zip.unzipFile(_: source, destination: destination, overwrite: false, password: nil, progress: progress)
        }
        catch
        {
            errorPtr?.pointee = error as NSError
        }
    }
}
