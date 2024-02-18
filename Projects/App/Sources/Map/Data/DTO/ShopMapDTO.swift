//
//  ShopMapDTO.swift
//  Winey
//
//  Created by 박혜운 on 2/1/24.
//  Copyright © 2024 Winey. All rights reserved.
//

import Foundation

// MARK: - ShopMapDTO

public struct ShopMapDTO: Codable, Equatable {
  let shopId, latitude, longitude: Int
  let businessHour, imgUrl, address, phone: String
  let name: String
  let meter: Int
  let shopType: String
  let shopMoods: [String]
  let like: Bool
  
  func convert() -> ShopInfoModel {
    return .init(
      id: shopId,
      info: self
    )
  }
}

public struct ShopInfoModel: Identifiable, Equatable {
  public var id: Int
  public var info: ShopMapDTO
}

//public struct ShopInfo: Identifiable {
//  public let id: Int
//  let latitude, longitude: Int
//  let businessHour, imgUrl, address, phone: String
//  let name: String
//  let meter: Int
//  let shopType: String
//  let shopMoods: [String]
//  let like: Bool
//}
