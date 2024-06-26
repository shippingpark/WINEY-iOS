//
//  TwoSectionBottomSheet.swift
//  Winey
//
//  Created by 정도현 on 5/22/24.
//  Copyright © 2024 Winey. All rights reserved.
//

import CombineExt
import ComposableArchitecture
import Foundation

public enum TwoSectionBottomSheetMode: Equatable {
  case noteDetail(NoteDetail.State)
  
  public var firstTitle: String {
    switch self {
    case .noteDetail:
      return "삭제하기"
    }
  }
  
  public var secondTitle: String {
    switch self {
    case .noteDetail:
      return "수정하기"
    }
  }
}

public struct TwoSectionBottomSheet: Reducer {
  public struct State: Equatable {
    
    public var noteDetail: NoteDetail.State?
    
    public var sheetMode: TwoSectionBottomSheetMode
    
    public init(sheetMode: TwoSectionBottomSheetMode) {
      self.sheetMode = sheetMode
    }
  }
  
  public enum Action {
    // MARK: - User Action
    case tappedFirstButton
    case tappedSecondButton
    
    // MARK: - Inner Business Action
    case _onAppear
    case _onDisappear
    
    // MARK: - Inner SetState Action
    
    // MARK: - Child Action
    case noteDetail(NoteDetail.Action)
  }

  public var body: some ReducerOf<Self> {
    Reduce<State, Action> { state, action in
      switch action {
      case ._onAppear:
        switch state.sheetMode {
        case .noteDetail(let data):
          state.noteDetail = data
        }
        return .none
        
      case .tappedFirstButton:
        switch state.sheetMode {
        case .noteDetail:
          return .send(.noteDetail(.tappedOption(.remove)))
        }
        
      case .tappedSecondButton:
        switch state.sheetMode {
        case .noteDetail:
          return .send(.noteDetail(.tappedOption(.modify)))
        }
        
      default:
        return .none
      }
    }
    .ifLet(\.noteDetail, action: /Action.noteDetail) {
      NoteDetail()
    }
  }
}
