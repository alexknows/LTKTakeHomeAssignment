//
//  ParentJson.swift
//  LTK
//
//  Created by Alex Cruz on 1/26/22.
//

import Foundation

struct ParentJson<T>: Decodable where T: Decodable {
    let data: T
}
