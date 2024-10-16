//
//  WineDetailInfoCore.swift
//  Winey
//
//  Created by 정도현 on 2023/09/06.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import ComposableArchitecture
import Foundation
import SwiftUI

public struct WineDetail: Reducer {
  public struct State: Equatable {
    let wineId: Int
    let wineCardData: RecommendWineData
    var windDetailData: WineDTO?
    var recommendWineTastingNotesList: SpecificWineTastingNotes.State
    
    public init(
      windId: Int,
      wineCardData: RecommendWineData
    ) {
      self.wineId = windId
      self.wineCardData = wineCardData
      self.recommendWineTastingNotesList = .init(wineId: wineId) // 임시
    }
  }
  
  public enum Action {
    // MARK: - User Action
    case tappedBackButton
    
    // MARK: - Inner Business Action
    case _viewWillAppear
    
    // MARK: - Inner SetState Action
    case _setDetailData(WineDTO)
    case _failureSocialNetworking(Error) // 후에 경고창 처리
    
    // MARK: - Child Action
    case _recommendWineTastingNotesList(SpecificWineTastingNotes.Action)
  }
  
  @Dependency(\.wine) var wineService
  
  public var body: some ReducerOf<Self> {
    
    Scope(state: \.recommendWineTastingNotesList, action: /Action._recommendWineTastingNotesList) {
      SpecificWineTastingNotes()
    }
    
    Reduce { state, action in
      switch action {
      case ._viewWillAppear:
        let id = String(state.wineId)
        
        return .run(operation: { send in
          switch await wineService.winesDetail(id) {
          case let .success(dto):
            await send(._setDetailData(dto))
          case let .failure(error):
            await send(._failureSocialNetworking(error))
          }
        })
        
      case let ._setDetailData(data):
        state.windDetailData = data
        return .none
        
      case .tappedBackButton:
        return .none
        
      default:
        return .none
      }
    }
  }
}
