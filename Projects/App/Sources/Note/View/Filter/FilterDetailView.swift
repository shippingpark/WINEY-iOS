//
//  FilterDetailView.swift
//  Winey
//
//  Created by 정도현 on 1/11/24.
//  Copyright © 2024 Winey. All rights reserved.
//

import ComposableArchitecture
import SwiftUI
import WineyKit

public struct FilterDetailView: View {
  private let store: StoreOf<FilterDetail>
  @ObservedObject var viewStore: ViewStoreOf<FilterDetail>
  
  public init(store: StoreOf<FilterDetail>) {
    self.store = store
    self.viewStore = ViewStore(self.store, observe: { $0 })
  }
  
  public var body: some View {
    ZStack {
      WineyKitAsset.mainBackground.swiftUIColor.ignoresSafeArea()
      
      VStack(alignment: .leading, spacing: 0) {
        NavigationBar(
          title: "필터",
          leftIcon: WineyAsset.Assets.navigationBackButton.swiftUIImage,
          leftIconButtonAction: {
            viewStore.send(.tappedBackButton)
          },
          backgroundColor: WineyKitAsset.mainBackground.swiftUIColor
        )
        
        ScrollView(.horizontal) {
          LazyHStack(spacing: 5) {
            ForEach(viewStore.rebuyFilterBuffer.sorted(), id: \.self) { filter in
              selectedFilter(title: filter, type: .rebuy)
            }
            
            ForEach(viewStore.typeFilterBuffer.sorted(), id: \.self) { filter in
              selectedFilter(title: filter, type: .type)
            }
            
            ForEach(viewStore.countryFilterBuffer.sorted(), id: \.self) { filter in
              selectedFilter(title: filter, type: .country)
            }
          }
        }
        .frame(height: 42)
        .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
        .padding(.top, 3)
        .padding(.bottom, 10)
        
        Divider()
          .frame(height: 0.8)
          .overlay(WineyKitAsset.gray900.swiftUIColor)
        
        ScrollView {
          LazyVStack(alignment: .leading, spacing: 28) {
            filterList(title: "재구매", list: viewStore.rebuyFilter, buffer: viewStore.rebuyFilterBuffer)
            filterList(title: "와인종류", list: viewStore.typeFilter, buffer: viewStore.typeFilterBuffer)
            filterList(title: "생산지", list: viewStore.countryFilter, buffer: viewStore.countryFilterBuffer)
          }
          .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
          .padding(.bottom, 20)
        }
        .padding(.top, 20)
        
        Spacer()
        
        bottomArea()
      }
    }
    .navigationBarBackButtonHidden()
    .onAppear {
      viewStore.send(._detailViewWillAppear)
    }
  }
}

extension FilterDetailView {
  
  @ViewBuilder
  private func filterList(title: String, list: [FilterInfo], buffer: Set<String>) -> some View {
    VStack(alignment: .leading, spacing: 14) {
      Text(title)
        .wineyFont(.bodyB1)
      
      ScrollView(showsIndicators: false) {
        LazyVStack(alignment: .leading, spacing: 10) {
          ForEach(filterRows(list: list), id: \.self) { filters in
            HStack(spacing: 5) {
              ForEach(filters, id: \.title) { filter in
                defaultFilter(filterInfo: filter, buffer: buffer)
              }
            }
          }
        }
        .frame(width: UIScreen.main.bounds.width - 50, alignment: .leading)
      }
      .frame(maxWidth: .infinity)
    }
  }
  
  // MARK: 선택할 수 있는 모든 필터
  @ViewBuilder
  private func defaultFilter(filterInfo: FilterInfo, buffer: Set<String>) -> some View {
    HStack(spacing: 4) {
      Text(filterInfo.title)
        .foregroundStyle(buffer.contains(filterInfo.title) ? WineyKitAsset.main2.swiftUIColor : WineyKitAsset.gray700.swiftUIColor)
        .lineLimit(1)
      
      if let count = filterInfo.count {
        if count >= 1 {
          Text(count > 100 ? "100+" : count.description)
            .foregroundStyle(
              buffer.contains(
                where: { $0 == filterInfo.title }
              ) ? WineyKitAsset.main2.swiftUIColor :  WineyKitAsset.gray500.swiftUIColor
            )
        }
      }
    }
    .wineyFont(.captionB1)
    .padding(.vertical, 7.5)
    .padding(.horizontal, 10)
    .background(
      Capsule()
        .stroke(
          buffer.contains(filterInfo.title) ? WineyKitAsset.main2.swiftUIColor : WineyKitAsset.gray900.swiftUIColor
        )
    )
    .padding(1)
    .onTapGesture {
      viewStore.send(.tappedFilter(filterInfo))
    }
  }
  
  // MARK: 선택된 필터들 필터 모양
  @ViewBuilder
  private func selectedFilter(title: String, type: FilterType) -> some View {
    HStack(alignment: .center, spacing: 0) {
      Text(title)
      
      Image("filterXIcon")
        .onTapGesture {
          viewStore.send(.tappedFilterRemoveButton(title, type))
        }
    }
    .wineyFont(.captionB1)
    .foregroundStyle(WineyKitAsset.gray50.swiftUIColor)
    .padding(.vertical, 4)
    .padding(.horizontal, 10)
    .background(
      Capsule()
        .foregroundColor(WineyKitAsset.gray900.swiftUIColor)
    )
    .padding(1)
  }
  
  @ViewBuilder
  private func bottomArea() -> some View {
    HStack(spacing: 20) {
      Button(action: {
        viewStore.send(.tappedInitButton)
      }, label: {
        HStack(spacing: 6) {
          WineyAsset.Assets.reloadIcon.swiftUIImage
            .resizable()
            .frame(width: 14, height: 14)
          
          Text("필터 초기화")
            .foregroundStyle(.white)
        }
        .foregroundColor(WineyKitAsset.gray100.swiftUIColor)
        .wineyFont(.bodyB2)
      })
      
      WineyConfirmButton(
        title: "\(viewStore.rebuyFilterBuffer.count + viewStore.typeFilterBuffer.count + viewStore.countryFilterBuffer.count)개 옵션 적용하기",
        validBy: true,
        action: {
          viewStore.send(.tappedAdaptButton)
        }
      )
    }
    .padding(.vertical, 20)
    .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
    .background(WineyKitAsset.gray950.swiftUIColor)
  }
}

extension FilterDetailView {
  
  private func filterRows(list: [FilterInfo]) -> [[FilterInfo]] {
    var rows: [[FilterInfo]] = []
    var curRow: [FilterInfo] = []
    
    var curWidth: CGFloat = 0
    let screenWidth: CGFloat = UIScreen.main.bounds.width - 50  // 좌우 패딩 25 제거 -> 50
    
    list.forEach { filter in
      let nextWidth = getFilterSize(filter: filter.title) + 30  // 캡슐 모형 크기 보정 값 30 추가
      curWidth += nextWidth
      
      // 화면 밖으로 넘어간다면 다음 줄로 이동.
      if curWidth > screenWidth {
        curWidth = nextWidth
        
        rows.append(curRow)
        curRow.removeAll()
        curRow.append(filter)
      } else {
        curRow.append(filter)
      }
    }
    
    // safe check
    if !curRow.isEmpty {
      rows.append(curRow)
      curRow.removeAll()
    }
    
    return rows
  }
  
  // 해당 글자 크기 리턴.
  private func getFilterSize(filter: String) -> CGFloat {
    let font = UIFont.systemFont(ofSize: 15)
    let attributes = [NSAttributedString.Key.font: font]
    let size = (filter as NSString).size(withAttributes: attributes)
    return size.width
  }
}

#Preview {
  FilterDetailView(
    store: Store(
      initialState: FilterDetail.State(),
      reducer: {
        FilterDetail()
      }
    )
  )
}
