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
      case .routeAction(_, action: .note(.noteCardScroll(.tappedNoteCard(let noteData)))):
        // state.routes.append(.push(.noteDetail(.init(noteCardData: noteData))))
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
        
      case .routeAction(_, action: .note(.tappedNoteWriteButton)):
        state.routes.append(.push(.creatNote(.initialState)))
        return .none
        
      case .routeAction(_, action: .createNote(.routeAction(_, action: .wineSearch(.tappedBackButton)))):
        state.routes.pop()
        return .none
        
      case .routeAction(_, action: .createNote(.routeAction(_, action: .noteDone(.tappedButton)))):
        state.routes.pop()
        return .none
        
      case .routeAction(_, action: .createNote(.routeAction(_, action: .setMemo(._backToFirstView)))):
        state.routes.pop()
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
        
      case .routeAction(_, action: .note(._navigateToAnalysis)):
        state.routes.append(.push(.analysis(.initialState)))
        return .none
        
      case .routeAction(_, action: .analysis(.routeAction(_, action: .wineAnaylsis(.tappedBackButton)))):
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
