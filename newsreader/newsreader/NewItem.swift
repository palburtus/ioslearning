//
//  NewItem.swift
//  newsreader
//
//  Created by Alburtus, Patrick on 5/16/22.
//

import Foundation

struct NewsItem: Codable {
    let title: String?
    let data: [NewsData]
}
