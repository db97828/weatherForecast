//
//  ApiError.swift
//  KxForecast
//
//  Created by dabeen on 2021/03/02.
//

import Foundation

enum ApiError: Error {
    case unknown
    case invalidUrl(String)
    case invalidResponse
    case failed(Int)
    case emptyData
}
