//
//  TabCore.swift
//  Winey
//
//  Created by 박혜운 on 2023/08/10.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import Combine
import ComposableArchitecture
import Foundation

public struct TabBar: Reducer {
  public struct State: Equatable {
    var main: MainCoordinator.State?
    var map: MapCoordinator.State?
    var note: NoteCoordinator.State?
    var userInfo: UserInfoCoordinator.State?

    public var selectedTab: TabBarItem = .main
    public var isTabHidden: Bool = false
    
    public init(
      main: MainCoordinator.State,
      map: MapCoordinator.State,
      note: NoteCoordinator.State,
      userInfo: UserInfoCoordinator.State,
      isTabHidden: Bool
    ) {
      self.main = main
      self.map = map
      self.note = note
      self.userInfo = userInfo
      self.isTabHidden = isTabHidden
    }
  }
  
  public enum Action {
    // MARK: - User Action
    case tabSelected(TabBarItem)
    
    // MARK: - Inner Business Action
    case _setTabHiddenStatus(Bool)
    case _onSetting
    
    // MARK: - Inner SetState Action
    case _mapStreamConnect(TabBarItem)
    
    // MARK: - Child Action
    case main(MainCoordinator.Action)
    case map(MapCoordinator.Action)
    case note(NoteCoordinator.Action)
    case userInfo(UserInfoCoordinator.Action)
  }
  
  @Dependency(\.tap) var tapService
  var cancellables = Set<AnyCancellable>()
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case ._onSetting:
        return .run { send in
          tapService.adaptivePresentationControl()
        }
        
      case let.tabSelected(tab):
        state.selectedTab = tab
        return .send(._mapStreamConnect(tab))
        
      case let ._mapStreamConnect(tab):
        return .send(.map(.routeAction(0, action: .map(._tappedMapTabBarItem(tab == .map)))))
        
      case .main(.routeAction(_, action: .main(._viewWillAppear))):
        return .send(._setTabHiddenStatus(false))
        
      case .map(.routeAction(_, action: .map(._tabBarHidden))):
        return .send(._setTabHiddenStatus(true))
        
      case .map(.routeAction(_, action: .map(._tabBarOpen))):
        return .send(._setTabHiddenStatus(false))
        
      case ._setTabHiddenStatus(let status):
        state.isTabHidden = status
        return .none
        
      default:
        return .none
      }
    }
    .ifLet(\.main, action: /Action.main) {
      MainCoordinator()
    }
    .ifLet(\.map, action: /Action.map) {
      MapCoordinator()
    }
    .ifLet(\.note, action: /Action.note) {
      NoteCoordinator()
    }
    .ifLet(\.userInfo, action: /Action.userInfo) {
      UserInfoCoordinator()
    }
  }
}
