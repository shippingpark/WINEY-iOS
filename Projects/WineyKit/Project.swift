//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 박혜운 on 2023/07/31.
//

import ProjectDescription
import ProjectDescriptionHelpers

let infoPlist: [String: InfoPlist.Value] = [
  "CFBundleShortVersionString": "1.0",
  "CFBundleVersion": "1",
  "CFBundleDevelopmentRegion": "ko_KR",
  "UIUserInterfaceStyle": "Dark",
  "UIAppFonts": [
    "Item 0": "Pretendard-Medium.otf",
    "Item 1": "Pretendard-Bold.otf"
  ]
]

let wineyKitTargets: [Target] = [
    .init(name: "WineyKit",
          platform: .iOS,
          product: .framework,
          bundleId: "com.adultOfNineteen.wineyKit",
          deploymentTarget: .iOS(targetVersion: "15.0", devices: [.iphone]),
          infoPlist: .extendingDefault(with: infoPlist),
          sources: ["Sources/**"],
          resources: ["Resources/**"],
          dependencies: [
            .project(target: "Utils", path: "../Utils")
          ]
         )
]

let wineyKitProject = Project.init(name: "WineyKit",
                           organizationName: "com.adultOfNineteen",
                           targets: wineyKitTargets)