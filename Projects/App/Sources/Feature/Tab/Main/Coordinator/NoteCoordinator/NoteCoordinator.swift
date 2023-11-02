//
//  WritingNoteCoordinatorCore.swift
//  Winey
//
//  Created by 정도현 on 2023/08/22.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import Combine
import ComposableArchitecture
import Foundation
import TCACoordinators

public struct NoteCoordinator: Reducer {
  public struct State: Equatable, IndexedRouterState {
    public var routes: [Route<NoteScreen.State>]
    
    public init(
      routes: [Route<NoteScreen.State>] = [
        .root(
          .note(.init()),
          embedInNavigationView: true
        )
      ]
    ){
      self.routes = routes
    }
  }
  
  public enum Action: IndexedRouterAction {
    case updateRoutes([Route<NoteScreen.State>])
    case routeAction(Int, action: NoteScreen.Action)
  }
  
  public var body: some ReducerOf<Self> {
    Reduce<State, Action> { state, action in
      switch action {
      case let .routeAction(_, action: .note(.noteCardScroll(.noteCard(id: _, action: ._navigateToCardDetail(id, noteCardData))))):
        state.routes.append(.push(.noteDetail(.init(wineId: id, noteCardData: noteCardData))))
        return .none
        
      case .routeAction(_, action: .note(.noteFilterScroll(._navigateFilterSetting(let filterList)))):
        state.routes.append(
          .push(
            .filterList(
              .init(
                filterList: filterList
              )
            )
          )
        )
        return .none
        
      case .routeAction(_, action: .noteDetail(.tappedBackButton)):
        state.routes.pop()
        return .none
        
      case .routeAction(_, action: .filterList(.tappedAdaptButton)):
        state.routes.pop()
        return .none
        
      case .routeAction(_, action: .filterList(.tappedBackButton)):
        state.routes.pop()
        return .none
        
      default:
        return .none
      }
    }
    .forEachRoute {
      NoteScreen()
    }
  }
}
