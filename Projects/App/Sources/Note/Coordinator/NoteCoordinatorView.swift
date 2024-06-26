//
//  WritingNoteCoordinatorView.swift
//  Winey
//
//  Created by 정도현 on 2023/08/22.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import Combine
import ComposableArchitecture
import SwiftUI
import TCACoordinators

public struct NoteCoordinatorView: View {
  private let store: StoreOf<NoteCoordinator>
  
  public init(store: StoreOf<NoteCoordinator>) {
    self.store = store
  }
  
  public var body: some View {
    TCARouter(store) { screen in
      SwitchStore(screen) { screen in
        switch screen {
        case .note:
          CaseLet(
            /NoteScreen.State.note,
             action: NoteScreen.Action.note,
             then: NoteView.init
          )
        }
      }
    }
  }
}
