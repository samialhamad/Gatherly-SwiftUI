//
//  GetGroups.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 4/14/25.
//

import Foundation
import RxSwift

extension GatherlyAPI {
    static func getGroups() -> Observable<[UserGroup]> {
        Observable.just(SampleData.sampleGroups)
            .delay(.seconds(5), scheduler: MainScheduler.instance)
    }
}
