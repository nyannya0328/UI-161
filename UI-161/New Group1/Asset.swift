//
//  Asset.swift
//  UI-161
//
//  Created by にゃんにゃん丸 on 2021/04/15.
//

import SwiftUI
import Photos

struct Asset: Identifiable {
    var id = UUID().uuidString
    var asset : PHAsset
    var image : UIImage
}

