//
//  Error+Cancellation.swift
//  CineTrack
//
//  Created by Mehmet Jiyan Atalay on 27.11.2026.
//

import Foundation

extension Error {
    /// İptal edilen istekler (debounce, view'dan çıkış, refresh) kullanıcıya hata olarak gösterilmemeli.
    var isCancellation: Bool {
        if self is CancellationError { return true }
        if let urlError = self as? URLError { return urlError.code == .cancelled }
        if let apiError = self as? APIError, case .unknown(let underlying) = apiError {
            return underlying.isCancellation
        }
        return false
    }
}
