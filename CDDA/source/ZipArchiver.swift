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
    @objc class func zip(_ source: URL, destination: URL, progress: ((_ progress: Double) -> ())? = nil)
    {
        do
        {
            try Zip.zipFiles(paths: [source], zipFilePath: destination, password: nil, progress: progress)
        }
        catch
        {
            print("Error occured while zipping")
        }
    }
}
