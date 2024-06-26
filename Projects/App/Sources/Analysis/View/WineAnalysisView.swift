//
//  WineAnalysisView.swift
//  Winey
//
//  Created by 정도현 on 2023/09/14.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import ComposableArchitecture
import SwiftUI
import WineyKit

public struct WineAnalysisView: View {
  private let store: StoreOf<WineAnalysis>
  @ObservedObject var viewStore: ViewStoreOf<WineAnalysis>
  
  public init(store: StoreOf<WineAnalysis>) {
    self.store = store
    self.viewStore = ViewStore(self.store, observe: { $0 })
  }
  
  public var body: some View {
    VStack(spacing: 0) {
      navigation()
      
      content()
    }
    .bottomSheet(
      backgroundColor: WineyKitAsset.gray950.swiftUIColor,
      isPresented: viewStore.binding(
        get: \.isPresentedBottomSheet,
        send: .tappedOutsideOfBottomSheet
      ),
      headerArea: {
        WineyAsset.Assets.analysisNoteIcon.swiftUIImage
      },
      content: {
        CustomVStack(
          text1: "재구매 의사가 담긴",
          text2: "테이스팅 노트가 있는 경우에 볼 수 있어요!"
        )
        .popGestureDisabled()
      },
      bottomArea: {
        HStack {
          WineyConfirmButton(
            title: "확인",
            validBy: true,
            action: {
              viewStore.send(.tappedConfirmButton)
            }
          )
        }
        .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
      }
    )
    .onChange(of: viewStore.state.isPresentedBottomSheet) { sheetAppear in
      if sheetAppear {
        UIApplication.shared.endEditing()
      }
    }
    .onAppear {
      viewStore.send(._onAppear)
    }
    .background(WineyKitAsset.mainBackground.swiftUIColor)
    .navigationBarHidden(true)
  }
}

extension WineAnalysisView {
  
  @ViewBuilder
  private func navigation() -> some View {
    NavigationBar(
      leftIcon: WineyAsset.Assets.navigationBackButton.swiftUIImage,
      leftIconButtonAction: {
        viewStore.send(.tappedBackButton)
      },
      backgroundColor: WineyKitAsset.mainBackground.swiftUIColor
    )
  }
  
  @ViewBuilder
  private func content() -> some View {
    ZStack(alignment: .center) {
      WineyAsset.Assets.analysisBackground.swiftUIImage
        .resizable()
        .padding(.top, 34)
      
      VStack(spacing: 0) {
        analysisTitle()
        
        Spacer()
        
        analysisButton()
      }
      .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
    }
    .padding(.top, 20)
  }
  
  @ViewBuilder
  private func analysisTitle() -> some View {
    HStack {
      Text("나의")
        .foregroundColor(WineyKitAsset.gray50.swiftUIColor)
      Text("와인 취향")
        .foregroundColor(WineyKitAsset.main3.swiftUIColor)
      Text("분석")
        .foregroundColor(WineyKitAsset.gray50.swiftUIColor)
      
      Spacer()
    }
    .wineyFont(.title1)
    
    HStack {
      Text("작성한 테이스팅 노트를 기반으로 나의 와인 취향을 분석해요!")
        .foregroundColor(WineyKitAsset.gray700.swiftUIColor)
        .wineyFont(.captionB1)
      
      Spacer()
    }
    .padding(.top, 18)
  }
  
  @ViewBuilder
  private func analysisButton() -> some View {
    Button {
      viewStore.send(.tappedAnalysis)
    } label: {
      Text("분석하기")
        .wineyFont(.bodyB2)
        .foregroundColor(.white)
        .padding(.horizontal, 73)
        .padding(.vertical, 16)
        .background {
          RoundedRectangle(cornerRadius: 46)
            .fill(WineyKitAsset.main1.swiftUIColor)
            .shadow(color: WineyKitAsset.main1.swiftUIColor, radius: 8)
        }
    }
    .padding(.bottom, 84)
  }
}

public struct WineAnalysisView_Previews: PreviewProvider {
  public static var previews: some View {
    WineAnalysisView(
      store: Store(
        initialState: WineAnalysis.State.init(isPresentedBottomSheet: false),
        reducer: {
          WineAnalysis()
        }
      )
    )
  }
}
