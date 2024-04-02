//
//  AppScreenCore.swift
//  Winey
//
//  Created by 박혜운 on 2023/08/10.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import Combine
import ComposableArchitecture
import Foundation
import TCACoordinators


public struct AppScreen: Reducer {
  public enum State: Equatable {
    case splash(Splash.State)
    case auth(AuthCoordinator.State)
    case createNote(WritingNoteCoordinator.State)
    case analysis(WineAnalysisCoordinator.State)
    case wineTip(WineTipCoordinator.State)
    case recommendWine(RecommendWineCoordinator.State)
    case policy(WineyPolicy.State)
    case userSetting(UserSettingCoordinator.State)
    case tabBar(TabBar.State)
  }

  public enum Action {
    case splash(Splash.Action)
    case auth(AuthCoordinator.Action)
    case createNote(WritingNoteCoordinator.Action)
    case analysis(WineAnalysisCoordinator.Action)
    case wineTip(WineTipCoordinator.Action)
    case recommendWine(RecommendWineCoordinator.Action)
    case policy(WineyPolicy.Action)
    case userSetting(UserSettingCoordinator.Action)
    case tabBar(TabBar.Action)
  }
  
  public var body: some ReducerOf<Self> {
    Scope(state: /State.splash, action: /Action.splash) {
      Splash()
    }
    Scope(state: /State.auth, action: /Action.auth) {
      AuthCoordinator()
    }
    Scope(state: /State.createNote, action: /Action.createNote) {
      WritingNoteCoordinator()
    }
    Scope(state: /State.analysis, action: /Action.analysis) {
      WineAnalysisCoordinator()
    }
    Scope(state: /State.wineTip, action: /Action.wineTip) {
      WineTipCoordinator()
    }
    Scope(state: /State.recommendWine, action: /Action.recommendWine) {
      RecommendWineCoordinator()
    }
    Scope(state: /State.policy, action: /Action.policy) {
      WineyPolicy()
    }
    Scope(state: /State.userSetting, action: /Action.userSetting) {
      UserSettingCoordinator()
    }
    Scope(state: /State.tabBar, action: /Action.tabBar) {
      TabBar()
    }
  }
}
